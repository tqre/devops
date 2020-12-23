import gitlab
import requests

# Authentication token has to be acquired manually after instance is up and running.
with open('../secrets/token_api', 'r') as file:
    token_api = file.read()

# Self-signed certificate verification
ses = requests.Session()
ses.verify = '../secrets/gitlab.crt'

# Create a connection object
gl = gitlab.Gitlab('https://gitlab.tqre.fi', private_token=token_api, session=ses)

# Configure the GitLab instance
# https://docs.gitlab.com/ce/api/settings.html
conf = gl.settings.get()
conf.auto_devops_enabled = False
conf.first_day_of_week = 1
conf.signup_enabled = False
conf.max_artifacts_size = 3072
conf.save()

# Set default branch to the GitLab -specific one with the CI file
selinux_repo = gl.projects.get(gl.projects.list(search='selinux')[0].id)
selinux_repo.default_branch = "gitlab-ci"
selinux_repo.save()
