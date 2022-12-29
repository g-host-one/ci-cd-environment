# CI CD Environment

## htpasswd

Format: username:enc_passwd

Encrypt password for basic authentication:
```
openssl passwd 
```
-----------------------------------------------------------------

## Local configure

### Set up the repository

Get repository gpg key:
```
curl -fsSLk https://<domain>/repo/ubuntu/gpg -u "<login>:<passwd>" | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/<repo name>.gpg
```

/etc/apt/sources.list.d/\<repo name>.list
```
deb [arch=amd64] https://<domain>/repo/ubuntu/ stable main
```

/etc/apt/auth.conf.d/\<repo name>.conf
```
machine <domain>
  login <login>
  password <passwd>
```

### Accept an invalid certificate

/etc/apt/apt.conf.d/\<repo name>

```
Acquire::https::<domain>::Verify-Peer "false";
Acquire::https::<domain>::Verify-Host "false";
```

### Accept unsigned repository

/etc/apt/apt.conf.d/\<repo name>

```
Acquire::https::<domain name>::AllowInsecureRepositories "true";
```
change 
```
deb [arch=amd64] https://<domain>/repo/ubuntu/ stable main
```
to
```
deb [arch=amd64 trusted=yes] https://<domain>/repo/ubuntu/ stable main
```

-----------------------------------------------------------------

## Generate GPG key

Set custop GPG home directory
```
export GNUPGHOME="./pgp-xxx"
```

Generate key
```
gpg --batch --gen-key <<EOF
Key-Type: RSA
Key-Length: 4096
Name-Real: Private Repo
Name-Email: private@repo.com
Expire-Date: 0
%no-ask-passphrase
%no-protection
%commit
EOF
```

Export the public key:
```
gpg --armor --export "Private Repo" > ./pgp-key.public
```

Export the private key:
```
gpg --armor --export-secret-keys "Private Repo" > ./pgp-key.private
```