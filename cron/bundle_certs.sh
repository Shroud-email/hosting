#!/bin/bash
set -e

if [ -z "$EMAIL_DOMAIN" ]; then echo "EMAIL_DOMAIN is not set"; exit 1; fi

CERT_DIR="/caddy/certificates/acme-v02.api.letsencrypt.org-directory/$EMAIL_DOMAIN"
LEAF="$CERT_DIR/${EMAIL_DOMAIN}.crt"
KEY="$CERT_DIR/${EMAIL_DOMAIN}.key"

if [ ! -s "$LEAF" ] || [ ! -s "$KEY" ]; then
  echo "Caddy cert not ready yet ($LEAF); skipping"
  exit 0
fi

echo "Copying Caddy certs to Haraka..."
# Caddy's {domain}.crt is already the full chain (leaf + intermediates).
# Copy it verbatim — appending a separate intermediate would duplicate/break the chain.
cp "$KEY" /pem/tls_key.pem
cp "$LEAF" /pem/tls_cert.pem
echo "Copied Caddy certs to Haraka."
