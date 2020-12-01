import gitlab

# Authentication token has to be acquired manually
with open('../secrets/token_api', 'r') as file:
    token = file.read()

gl = gitlab.Gitlab('https://gitlab.tqre.fi', private_token=token)

print(gl.api_version)