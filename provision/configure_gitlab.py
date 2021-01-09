import gitlab
import requests

# https://python-gitlab.readthedocs.io/en/stable/api/gitlab.v4.html

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
conf.home_page_url = "https://gitlab.tqre.fi/selinux/selinux"
conf.first_day_of_week = 1
conf.signup_enabled = False
conf.max_artifacts_size = 3072
conf.save()

# Set default branch to the GitLab -specific one with the CI file
selinux_repo = gl.projects.get(gl.projects.list(search='selinux')[0].id)
selinux_repo.default_branch = "gitlab-ci"

# Set group visibility to public
group = gl.groups.get(gl.groups.list(search='selinux')[0].id)
group.visibility = "public"
group.save()

# Set project visibility: "public" doesn't allow edits and runs for the general public
selinux_repo.visibility = "public"
selinux_repo.request_access_enabled = False

selinux_repo.save()
