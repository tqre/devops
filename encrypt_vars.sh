#!/bin/bash
# Helper script to generate encrypted variables to GitLab installation playbook

# List of the files to be created into secrets/ -directory
FILES=(
	gitlab_secret
	gitlab_shell_secret
	secret_key_base
	db_key_base
	otp_key_base
	openid_connect_signing_key
)

# Check that none the files exist, as we don't want to overwrite any
for file in ${FILES[@]};do
  if [[ ! -f secrets/$file ]]; then continue
    else echo "Some files exist already, aborting..."; exit
  fi
done

if [[ -f secrets/dbadminpasswd  ]]; then
  echo "Database admin password exists already, aborting"; exit
fi

if [[ -f secrets/gitlabrootpasswd  ]]; then
  echo "GitLab root password exists already, aborting"; exit
fi

# Generate GitLab root account password and the encypted version
</dev/urandom tr -dc _A-Za-z0-9 | head -c32 > secrets/gitlabrootpasswd
ansible-vault encrypt_string $(<secrets/gitlabrootpasswd) --name gitlabrootpasswd > provision/encrypted_variables.yml

# Generate database admin password and the encrypted version
</dev/urandom tr -dc _A-Za-z0-9 | head -c32 > secrets/dbadminpasswd
ansible-vault encrypt_string $(<secrets/dbadminpasswd) --name dbadminpasswd >> provision/encrypted_variables.yml

# Generate random strings into each file
for file in ${FILES[@]}; do
  hexdump -v -n 64 -e '1/1 "%02x"' /dev/urandom > secrets/$file
done

# Encrypt strings with ansible-vault
for file in ${FILES[@]}; do
  ansible-vault encrypt_string $(<secrets/$file) --name $file >> provision/encrypted_variables.yml
done

echo "Playbook -ready encrypted variables are in provision/encrypted_variables.yml -file"
