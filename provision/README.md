# Ansible

Learning ansible by making a native GitLab installation manually.

Usage:
`ansible-playbook install_gitlab.yml`  
- vault password file is defined as an environment variable in /layout.yaml (tmuxp)
- sudo become password is defined in inventory, and is in vault

Playbooks:
- full system update
- install_gitlab
- configure_gitlab
