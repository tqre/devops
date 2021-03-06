#!/bin/bash
# Helper script to generate encrypted variables to GitLab installation playbook

# Target directories
SEC_DIR=secrets
ENC_FILE=provision/encrypted_variables.yml

# Encryption keys needed by GitLab
KEYS=(
	enckey_db_key_base
	enckey_gitlab_secret
	enckey_gitlab_shell_secret
	enckey_openid_connect_signing_key
	enckey_otp_key_base
	enckey_secret_key_base
)

# Passwords needed
PASSWDS=(
	passwd_ansible_vault
	passwd_dbadmin
	passwd_gitlab_admin
	passwd_gitlab_user
	passwd_server_sudo
)	

# Check that none the files exist, as we don't want to overwrite any

for file in ${KEYS[@]}; do
  if [[ -f $SEC_DIR/$file ]]; then 
    echo "Some files exist already, aborting..."; exit
  fi
done

for file in ${PASSWDS[@]}; do
  if [[ -f $SEC_DIR/$file ]]; then
    echo "Some files exist already, aborting"...; exit
  fi
done

echo "Creating Ansible vault file..."
echo "# Autogenerated encrypted secrets" > $ENC_FILE

for file in ${PASSWDS[@]}; do
  echo "Generating $file and writing it to $ENC_FILE"
  </dev/urandom tr -dc A-Za-z0-9 | head -c32 > $SEC_DIR/$file
  ansible-vault encrypt_string $(<$SEC_DIR/$file) --name $file >> $ENC_FILE
done

# Generate random strings for GitLab encryption keys and store them as ansible vault variables
for file in ${KEYS[@]}; do
  echo "Generating $file and writing it to $ENC_FILE"
  hexdump -v -n 64 -e '1/1 "%02x"' /dev/urandom > $SEC_DIR/$file
  ansible-vault encrypt_string $(<$SEC_DIR/$file) --name $file >> $ENC_FILE
done

# Generate the SSL certificate from config file
openssl req -x509 -newkey ec -pkeyopt ec_paramgen_curve:secp384r1 \
	-nodes -config cert.conf	\
	-out $SEC_DIR/gitlab.crt	\
	-keyout $SEC_DIR/gitlab.key	\
	-extensions req_ext
