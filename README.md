# DevOps - GitLab server setup scripts
DevOps and DevSecOps study infrastructure setup scripts  

The server is up and running at https://gitlab.tqre.fi

`secrets/cloud_creds` - Cloud API credentials are needed

## Process

1. Deploy VM instance to cloud with cloud-API scripts
- deploy/deploy_server.py

2. Create the needed secrets with te helper script
- generate_secrets.sh

3. Provision server with GitLab using Ansible
- provision/install_gitlab.yml

4. Configure GitLab further 
- GitLab instance's root password is in secrets/passwd_gitlab_admin
- gitlab-runner configuration playbook
- additional application settings with API?

5. Backups
- even though the server can be trashed and created anew within few minutes, backing up the content is essential

