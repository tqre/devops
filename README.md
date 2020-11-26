# DevOps - GitLab server setup scripts
DevOps and DevSecOps study infrastructure setup scripts  

The server is up and running at https://gitlab.tqre.fi

## Credentials and secrets
`secrets/`  is not included in this repo for obvious reasons. It contains the following files that are needed:  
`secrets/cloud_creds` - Cloud API credentials  
`secrets/sudo_passwd` - administrative password  
`secrets/ansible_vault` - ansible vault password file  
`secrets/gitlab.{key,crt}` - temporary SSL certificates for testing

`encrypt_vars.sh` -script needs to be run before the install_gitlab playbook. It generates secret strings that are used to generate authentication tokens etc.

## Process

1. Deploy VM instance to cloud with cloud-API scripts
- deploy/deploy_server.py

2. Provision server with GitLab using Ansible
- provision/install_gitlab.yml

3. Configure GitLab via browser interface
- set up users and passwords, import SELinux repo for CI/CD construction

4. Backups
- even though the server can be trashed and created anew within few minutes, backing up the content is essential

