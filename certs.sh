#!/bin/sh
set -eu
mkdir -p certs
umask 077
openssl req -x509 -newkey rsa:2048 -nodes -days 365 -keyout certs/ca-key.pem -out certs/ca.pem -subj '/CN=KR2 CA'
for kind in server client; do
 openssl req -new -newkey rsa:2048 -nodes -keyout certs/$kind-key.pem -out certs/$kind.csr -subj "/CN=$kind"
 if [ "$kind" = server ]; then
  printf 'subjectAltName=IP:127.0.0.1\nextendedKeyUsage=serverAuth\n' > certs/extensions.cnf
 else
  printf 'extendedKeyUsage=clientAuth\n' > certs/extensions.cnf
 fi
 openssl x509 -req -in certs/$kind.csr -CA certs/ca.pem -CAkey certs/ca-key.pem -CAcreateserial -days 365 -out certs/$kind.pem -extfile certs/extensions.cnf
done
