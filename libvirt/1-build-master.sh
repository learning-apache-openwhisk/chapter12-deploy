#!/bin/bash
if test "$(whoami)" != "root"
then echo "Run me as root, please." ; exit 1
fi
ROOTPW="${1:?root password}"
DISK="${2:?disk size in GB}"
apt-get -y upgrade
apt-get -y install libvirt-bin virtinst cloud-utils
if ! grep "^net\.ipv4\.ip_forward=1" /etc/sysctl.conf
then echo "net.ipv4.ip_forward=1" >>/etc/sysctl.conf
     sysctl -p
fi
mkdir /var/lib/libvirt/kube
cd /var/lib/libvirt/kube
test -e base.img || curl -L https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img >base.img
curl -L https://learning-apache-openwhisk.github.io/chapter12-deploy/user-data.txt >user-data.txt
cat <<EOF >>user-data.txt
chpasswd:
  list:
   - root:$ROOTPW
EOF
cloud-localds master.iso user-data.txt
cp base.img master.img
qemu-img resize master.img 20G
virsh net-update default add ip-dhcp-host \
"<host mac='52:54:00:92:68:10' name='master' \
ip='192.168.122.10' />" --live --config
