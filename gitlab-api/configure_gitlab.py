import gitlab
import requests

# Authentication token has to be acquired manually
with open('../secrets/token_api', 'r') as file:
    token = file.read()

# Self-signed certificate verification
ses = requests.Session()
ses.verify = '../secrets/gitlab.crt'

# Create a connection object
gl = gitlab.Gitlab('https://gitlab.tqre.fi', private_token=token, session=ses)

settings = gl.settings.get()
settings.signup_enabled = False
settings.save()