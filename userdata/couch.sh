distro="$(lsb_release -c -s)"
curl -L https://couchdb.apache.org/repo/bintray-pubkey.asc \
| sudo apt-key add -
echo "deb https://apache.bintray.com/couchdb-deb $distro main" \
| sudo tee -a /etc/apt/sources.list
apt-get -y update
apt-get -y --allow-unauthenticated install "couchdb=2.1.2~$distro"
