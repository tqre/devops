# DevOps - GitLab server setup scripts
DevOps and DevSecOps study infrastructure setup scripts

## Credentials
`secrets/` -directory is used to fetch credentials from, and is not included in this repo for obvious reasons. 

The following files are used in deploy phase:  
`secrets/cloud_creds` - Cloud API credentials  
`secrets/sudo_passwd` - administrative password  

ansible vault stuff  

## Process
1. Deploy VM instance to cloud with cloud-API scripts
- deploy/deploy_server.py

2. Provision server with GitLab using ansible
- provision/install_gitlab.yml
