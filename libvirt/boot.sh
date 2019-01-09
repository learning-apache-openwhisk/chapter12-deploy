ID=${1:?id}
MEM=${2:?memory}
OPT=${3:-}
ENTRY="<host name='node$ID' ip='192.168.122.$ID' mac='52:54:00:92:68:$ID'/>"
virsh net-update default add ip-dhcp-host "$ENTRY" --live --config
virt-install \
--name node$ID \
--ram $(expr $MEM \* 1024) \
--vcpu 2 \
--disk path=$PWD/node$ID.img \
--disk path=$PWD/node$ID.iso,device=cdrom \
--os-type linux \
--os-variant ubuntu16.04 \
--network bridge=virbr0,mac=52:54:00:92:68:$ID \
--graphics none \
--console pty,target_type=serial \
$OPT