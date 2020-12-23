# DevOps - GitLab server setup scripts
DevOps and DevSecOps study infrastructure setup scripts  

`secrets/cloud_creds` - Cloud API credentials in base64 encoding
`deploy/bootstrap.sh' - SSH keypair's public part is needed here

## Process

1. Create the needed secrets with te helper script
- generate_secrets.sh

2. Deploy VM instance to cloud with cloud-API scripts
- deploy/deploy_server.py

3. DNS configuration via external services
- TODO: centralize the configuration

4. Configure server and install GitLab using Ansible
- provision/server_config.yml
- provision/install_gitlab.yml

5. Configure GitLab further 
- Log in to GitLab instance web UI as root and acquire needed tokens (api + shared runner registration)
- place them in secrets/ and encrypt them for ansible use
  - encrypt_tokens.sh
- provision/configure_gitlab.yml
- additional application settings with python-API
  - configure_gitlab.py

6. Backups?
- even though the server can be trashed and created anew within few minutes, backing up the content is essential

