#!/bin/bash
if test "$(whoami)" != "root"
then echo "Run me as root, please." ; exit 1
fi
if ! test -d "/var/lib/libvirt/kube"
then echo "Run one of the init-*.sh script before this"; exit 1
fi
N="${1:?node number}"
: "${DISK:=20}"
: "${MEM:=4096}"
INIT="${2:-}"
IP="$(expr 10 + $N)"
MAC="$(printf '%02x' $IP)"
cd /var/lib/libvirt/kube
cp user-data.txt user-data$N.txt
if test -n "$INIT"
then echo "runcmd:\n- $INIT" >>user-data$N.txt
fi
cloud-localds kube$N.iso user-data$N.txt
cp base.img kube$N.img
qemu-img resize kube$N.img "${DISK}G"
virsh net-update default add ip-dhcp-host \
"<host mac='52:54:92:68:22:$MAC' name='kube$N' ip='192.168.122.$IP' />"\
--live --config
