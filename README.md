# DevOps - GitLab server setup scripts
DevOps and DevSecOps study infrastructure setup scripts  

The server is up and running at https://gitlab.tqre.fi

## Credentials and secrets created
`secrets/`  is not included in this repo for obvious reasons. It contains the following files that are needed:  
`secrets/cloud_creds` - Cloud API credentials  
`secrets/sudo_passwd` - administrative password  
`secrets/ansible_vault` - ansible vault password file  

`secrets/gitlab.{key,crt}` - self-signed SSL certificate

## Process

1. Deploy VM instance to cloud with cloud-API scripts
- deploy/deploy_server.py

2. Create the needed secrets with helper scritps
- encrypt_vars.sh
- make_cert.sh

3. Provision server with GitLab using Ansible
- provision/install_gitlab.yml

4. Configure GitLab further 
- users 
- gitlab-runner

5. Backups
- even though the server can be trashed and created anew within few minutes, backing up the content is essential

