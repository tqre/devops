# DevOps - GitLab server setup scripts
DevOps and DevSecOps study infrastructure setup scripts  

## Process

1. Edit server resources in deploy/arch.json
- location, title, hostname, CPU+RAM, HD
    
2. Edit up deploy/bootstrap.sh script
- SSH public key, hostname, partitioning, DNS servers

3. Create secrets/cloud_creds -file for UpCloud API access
- `$ echo -n "username:password" | base64 > secrets/cloud_creds`

4. Run helper script to create needed secret strings
- `$ ./generate_secrets.sh`

5. Deploy VM instance to cloud with API
- `$ cd deploy; python deploy_server.py`

6. Add DNS entries at your DNS service
- edit provision/config_files/gitlab.yml to reflect the domain name

7. Ansible-playbook: Set up firewall and other server configurations
- provision/server_config.yml

8. Install GitLab with Ansible
- provision/install_gitlab.yml

9. Configure GitLab further 
- Log in to GitLab instance web UI as root and acquire needed tokens (api + shared runner registration)
- place them in secrets/ and encrypt them for ansible use
  - encrypt_tokens.sh
- provision/configure_gitlab.yml
- additional application settings with python-API
  - configure_gitlab.py
