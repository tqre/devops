import gitlab
import requests

# Authentication token has to be acquired manually after instance is up and running.
# User password is generated with script generate_secrets.sh
with open('../secrets/token_api', 'r') as apitokenfile:
    token_api = apitokenfile.read()

with open('../secrets/token_runner', 'r') as runnertokenfile:
    token_runner_registration = runnertokenfile.read()

with open('../secrets/passwd_gitlab_user', 'r') as userpasswdfile:
    userpasswd = userpasswdfile.read()

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
conf.save()

# Create user
try:
    newuser = gl.users.create({
        'email': 'user@example.com',
        'skip_confirmation': True,
        'password': userpasswd,
        'username': 'testuser',
        'name': 'Test User'
    })

except gitlab.GitlabCreateError:
    print('User exists, did not create a new one')

# Create the selinux project for the user
try:
    user = gl.users.list(username='testuser')[0]
    user_project = user.projects.create({
        'name': 'selinux',
        'description': 'SELinux support packages for Arch Linux',
        'import_url': 'https://github.com/tqre/selinux',
        'visibility': 'private'
    })

except gitlab.GitlabCreateError:
    print('Project exists, did not create a new one')

# Create a shared runner for the instance
runner = gl.runners.create({
    'token': token_runner_registration,
    'description': 'shared test runner',
    'url': 'https://gitlab.tqre.fi'
})

