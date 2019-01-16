#!/bin/sh
DOMAIN=${1:?DOMAIN}
EMAIL=${2:?EMAIL}
shift 2
if grep '[acme]' /etc/traefik.toml
then echo "Acme already installed"; exit
fi
echo "*** Installing Let's Encrypt Certificate ***"
cat <<EOF >>/etc/traefik.toml
[acme]
email = "$EMAIL"
storage = "/etc/acme.json"
acmeLogging = true
entryPoint = "https"
[acme.httpChallenge]
entryPoint = "http"
[[acme.domains]]
main = "$DOMAIN"
EOF
