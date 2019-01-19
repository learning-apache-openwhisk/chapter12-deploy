for ID in "$@" 
do virsh destroy node$ID
   virsh undefine node$ID
   ENTRY="<host name='node$ID' ip='192.168.122.$ID' mac='52:54:00:92:68:$ID'/>"
   virsh net-update default delete ip-dhcp-host  "$ENTRY" --live --config
   rm node$ID.img node$ID.iso user-data-$ID.txt
done
