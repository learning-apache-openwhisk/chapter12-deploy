#!/bin/bash
IMAGE=https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img
if test "$(whoami)" != "root"
then echo "Run me as root, please." ; exit 1
fi
ROOTPW="${1:?root password for images}"
apt-get -y upgrade
apt-get -y install libvirt-bin virtinst cloud-utils
if ! grep "^net\.ipv4\.ip_forward=1" /etc/sysctl.conf
then echo "net.ipv4.ip_forward=1" >>/etc/sysctl.conf
     sysctl -p
fi
mkdir /var/lib/libvirt/kube
cd /var/lib/libvirt/kube
curl -L "$IMAGE" >base.img
cp "$(dirname $0)/user-data.txt" /var/lib/libvirt/kube/user-data.txt
cat <<EOF >>user-data.txt
chpasswd:
  list:
   - root:$ROOTPW
EOF
