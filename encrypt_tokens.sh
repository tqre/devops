#!/bin/bash
# Encrypt GitLab API-tokens and a regular user secrets to a variable file
# The tokens have to be fetched manually from a working GitLab instance

SEC_DIR=secrets
ENC_FILE=provision/encrypted_tokens.yml

TOKENS=(
	token_api
	token_runner
)

for token in ${TOKENS[@]}; do
  if [[ ! -f secrets/$token ]]; then
    echo "No $token found. Aborting..."; exit
  fi
  ansible-vault encrypt_string $(<$SEC_DIRE/$token) --name $token >> $ENC_FILE
done




