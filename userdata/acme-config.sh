#!/bin/sh
if test "$(whoami)" != root
then echo "Please, run me as 'sudo $0 $@'" ; exit 1
fi
DOMAIN=${1:?DOMAIN}
EMAIL=${2:?EMAIL}
shift 2
if fgrep '[acme]' /etc/traefik.toml
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
systemctl restart traefik

