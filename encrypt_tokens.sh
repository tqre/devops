#!/bin/bash
# Encrypt GitLab API-tokens and a regular user secrets to a variable file

TOKENS=(
	api_token
	runner_token
)

# Generate a password for a regular GitLab user
</dev/urandom tr -dc _A-Za-z0-9 | head -c32 > secrets/user_password
ansible-vault encrypt_string $(<secrets/user_password) --name user_password > provision/encrypted_tokens.yml

for token in ${TOKENS[@]}; do
  if [[ ! -f secrets/$token ]]; then
    echo "No $token found from secrets/ -directory! Aborting..."; exit
  fi
  ansible-vault encrypt_string $(<secrets/$token) --name $token >> provision/encrypted_tokens.yml
done




