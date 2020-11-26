# DevOps - GitLab server setup scripts
DevOps and DevSecOps study infrastructure setup scripts

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

2. Provision server with GitLab using ansible
- provision/install_gitlab.yml

3. Browse to the public IP of the server and set up root password

4. Backups?

