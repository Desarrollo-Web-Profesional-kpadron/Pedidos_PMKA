#!/bin/sh

# Crear directorio para certificados
mkdir -p nginx/ssl

# Generar certificado autofirmado
openssl req -x509 \
    -nodes \
    -days 365 \
    -newkey rsa:2048 \
    -keyout nginx/ssl/nginx.key \
    -out nginx/ssl/nginx.crt \
    -subj "/C=MX/ST=Ciudad/L=Ciudad/O=MiOrganizacion/OU=TI/CN=localhost"

echo "Certificados SSL generados en nginx/ssl/"