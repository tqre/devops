import json
import http.client
import sys
from vncdotool import api as vncapi
from time import sleep


def main():

    # Read server specs from a file
    with open('arch.json', 'r') as file:
        server_specs = file.read()

    # Deploy the server and save it as a Server object
    data = json.loads(upcloud.do('POST', '/server', server_specs))
    server = Server(data, upcloud)
    print('Server public IP address: ' + server.ip)
    server.wait_until('started')

    # Send commands to server with vnc connection
    vnc_client = VNCConnection(server)
    print("Sending commands via VNC connection:")

    # Update package repositories and pacman keyring
    # NOTE: the colon ':' and plus-sign '+' are NOT usable with the connection
    vnc_client.cmd('pacman -Sy')
    vnc_client.cmd('pacman -S archlinux-keyring --noconfirm')

    # Download the bootstrap script and run it
    vnc_client.cmd('curl raw.githubusercontent.com/tqre/devops/main/README.md --output bootstrap.sh')
    vnc_client.cmd('chmod 777 bootstrap.sh')
    vnc_client.cmd('./bootstrap.sh')

class UpCloudAPIConnection:

    def __init__(self):
        self.address = "api.upcloud.com"
        self.version = "/1.3"
        print("Connecting to " + self.address + "...")

        with open('secrets', 'rb') as creds:
            self.credentials = creds.read()

        self.test_credentials()

    def conn(self, httpreq, url, body=None):
        connection = http.client.HTTPSConnection(self.address)
        url = self.version + url
        headers = {"Authorization": "Basic " + self.credentials.decode(),
                   "Accept": "application/json",
                   "Content-Type": "application/json"}
        connection.request(httpreq, url, body, headers)
        return connection.getresponse()

    def test_credentials(self):
        if self.conn("GET", "/account").status != 200:
            print("Authentication failed, exiting...")
            exit()

        print("Authentication success.")

    def do(self, httpreq, url, body=None):
        return self.conn(httpreq, url, body).read().decode(encoding="UTF-8")


# Servers are associated with a connection when created
class Server:
    def __init__(self, data, connection):
        self.data = data
        self.conn = connection
        self.uuid = data['server']['uuid']
        self.state = data['server']['state']
        self.ip = data['server']['ip_addresses']['ip_address'][0]['address']
        self.vnc_passwd = data['server']['remote_access_password']

        try:
            self.vnc_address = data['server']['remote_access_host']
            self.port_fix(int(data['server']['remote_access_port']))

        except KeyError:
            self.vnc_address = ""
            self.vnc_port = ""

    # Fix port number bug in vncdotool for non-standard ports
    def port_fix(self, old_port):
        old_port -= 5900
        self.vnc_port = str(old_port)

    # A counter to wait for machine state change
    def wait_until(self, state, interval=1):

        # Possible states: started, stopped, maintenance, error
        time_elapsed = 0
        while True:
            data = json.loads(self.conn.do('GET', '/server/' + self.uuid))
            self.state = data['server']['state']
            if self.state == state:
                print("\nServer is now " + self.state)
                break

            sys.stdout.write("\rWaiting [" + str(time_elapsed) + "s] for server status change: " + self.state + " -> " + state)
            sys.stdout.flush()
            time_elapsed += interval
            sleep(interval)


class VNCConnection:

    def __init__(self, server):
        self.server = server
        self.address = server.vnc_address + ":" + server.vnc_port
        self.passwd = server.vnc_passwd
        self.connection = vncapi.connect(self.address, password=self.passwd)
        self.connection.keyPress('enter')
        print("Waiting for the installation ISO to boot...")
        self.connection.expectScreen('pics/booted_install_ISO.png')

    def cmd(self, string):
        print('# ' + string)
        for char in string:
            self.connection.keyPress(char)
            sleep(.2)
        self.connection.keyPress('enter')


if __name__ == "__main__":
    upcloud = UpCloudAPIConnection()
    main()
