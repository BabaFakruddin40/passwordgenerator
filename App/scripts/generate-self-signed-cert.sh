#!/usr/bin/env sh
# Generates a self-signed TLS cert/key for local development into ../certs
# For production, replace certs/server.crt and certs/server.key with certs from a real CA (e.g. Let's Encrypt).
set -e

CERT_DIR="$(cd "$(dirname "$0")/.." && pwd)/certs"
mkdir -p "$CERT_DIR"

openssl req -x509 -nodes -newkey rsa:2048 \
  -keyout "$CERT_DIR/server.key" \
  -out "$CERT_DIR/server.crt" \
  -days 365 \
  -subj "/CN=localhost" \
  -addext "subjectAltName=DNS:localhost,IP:127.0.0.1"

echo "Generated $CERT_DIR/server.crt and $CERT_DIR/server.key"
