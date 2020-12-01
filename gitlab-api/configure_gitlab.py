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

# Configure the GitLab instance
# https://docs.gitlab.com/ce/api/settings.html
conf = gl.settings.get()
conf.auto_devops_enabled = False
conf.first_day_of_week = 1
conf.signup_enabled = False


conf.save()