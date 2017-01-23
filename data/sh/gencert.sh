#! /bin/sh

# create self-signed server certificate:

SSL_PATH="/Users/lilclimate/Public/workspace/meizu_company/data/etc/nginx/ssl/certs"

chmod 755 ${SSL_PATH}

read -p "Enter your domain [www.example.com]: " DOMAIN

echo "Create server key..."

openssl genrsa -des3 -out ${SSL_PATH}/${DOMAIN}.key 1024

echo "openssl genrsa -des3 -out ${SSL_PATH}/${DOMAIN}.key 1024"
echo "Create server certificate signing request..."

SUBJECT="/C=US/ST=Mars/L=iTranswarp/O=iTranswarp/OU=iTranswarp/CN=$DOMAIN"

openssl req -new -subj $SUBJECT -key ${SSL_PATH}/${DOMAIN}.key -out ${SSL_PATH}/${DOMAIN}.csr

echo "Remove password..."

mv ${SSL_PATH}/${DOMAIN}.key ${SSL_PATH}/${DOMAIN}.origin.key
openssl rsa -in ${SSL_PATH}/${DOMAIN}.origin.key -out ${SSL_PATH}/${DOMAIN}.key

echo "Sign SSL certificate..."

openssl x509 -req -days 3650 -in ${SSL_PATH}/${DOMAIN}.csr -signkey ${SSL_PATH}/${DOMAIN}.key -out ${SSL_PATH}/${DOMAIN}.crt

echo "TODO:"
echo "Copy $DOMAIN.crt to ${SSL_PATH}/${DOMAIN}.crt"
echo "Copy $DOMAIN.key to ${DOMAIN}.key"
echo "Add configuration in nginx:"
echo "server {"
echo "    ..."
echo "    listen 443 ssl;"
echo "    ssl_certificate     ${SSL_PATH}/${DOMAIN}.crt;"
echo "    ssl_certificate_key ${SSL_PATH}/${DOMAIN}.key;"
echo "}"
