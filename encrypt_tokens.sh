#!/bin/bash
# Encrypt GitLab API-tokens and a regular user secrets to a variable file

TOKENS=(
	api_token
	runner_token
)

for token in ${TOKENS[@]}; do
  if [[ ! -f secrets/$token ]]; then
    echo "No $token found from secrets/ -directory! Aborting..."; exit
  fi
  ansible-vault encrypt_string $(<secrets/$token) --name $token >> provision/encrypted_tokens.yml
done




