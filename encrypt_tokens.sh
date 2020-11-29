#!/bin/bash
# Encrypt GitLab API-tokens and user data to a variable file

if [[ ! -f secrets/api_token ]]; then
  echo "No api_token found from secrets/ -directory! Aborting..."; exit
fi

ansible-vault encrypt_string $(<secrets/api_token) --name api_token > provision/encrypted_tokens.yml

# Generate a password for a regular GitLab user
</dev/urandom tr -dc _A-Za-z0-9 | head -c32 > secrets/user_password
ansible-vault encrypt_string $(<secrets/user_password) --name user_password >> provision/encrypted_tokens.yml
