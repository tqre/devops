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
- Log in to GitLab instance web UI as root and acquire needed tokens (api + shared runner registration)
- place them in secrets/ and encrypt them for ansible use
  - encrypt_tokens.sh
- additional application settings with python-API
  - configure_gitlab.py
- run configure_gitlab.yml playbook

5. Backups
- even though the server can be trashed and created anew within few minutes, backing up the content is essential

