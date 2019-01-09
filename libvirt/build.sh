ID=${1:?id}
SZ=${2:?size}
INIT="${3:-}"
UD=user-data-$ID.txt
cp base.img node$ID.img
cp user-data.txt $UD
qemu-img resize node$ID.img ${SZ}G
echo "hostname: node$ID">>$UD
echo "runcmd:" >>$UD
test -z "$INIT" || echo "- $INIT">>$UD
cloud-localds node$ID.iso $UD
