apt-get -y upgrade
sudo apt-get -y install libvirt-bin virtinst cloud-utils
curl -L https://cloud-images.ubuntu.com/\
xenial/current/xenial-server-cloudimg-amd64-disk1.img \
>base.img
cp ../user-data.txt .
echo "ensure you enabled forwarding then sysctl -p"
echo "ensure you opened the firewall for ports 80,443,6443"
echo "ensure you forwarded ports 80,443,6443 to the master"
