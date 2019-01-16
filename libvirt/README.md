# Installation

Commands:

```
apt-get -y upgrade
sudo apt-get -y install libvirt-bin virtinst cloud-utils
mkdir /var/lib/libvirt/kube
cd /var/lib/libvirt/kube
curl -L https://learning-apache-openwhisk.github.io/chapter12-deploy/user-data.txt >user-data.txt
curl -L https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-disk1.img >base.img
```

# Configuration

Edit /etc/sysctl.conf and add:

```
net.ipv4.ip_forward=1
```

then execute

```
sysctl -p
```

# Building images

Edit the user data adding a password (change  the password to your own)

```
chpasswd:
  list:
   - root:Change-me!
```


Now prepare the master. Pick an "id" in the range 10 - 99. The `id` will be used as IP and MAC address and to name the Virtual Machine.

You can now build the image specifying the `id` and the size of the disk image in GB.

```
sh build.sh 10 20
```

After building the vm you can boot it, specifying the `id` and the size of the memory in GB too.

```
sh boot.sh 10 4
```

Wait until you see the message: 

```
Reached target Cloud-init target.
```

Press enter and login as `root`. Execute:

```
kube-provision <external-ip>
```

At the end, it will show a snippet to add to the userdata to join the cluster in the format:

```
runcmd:
- kubeadm join <various informations>
```


You need only the command part starting with `kubeadm`

Pick a few more ids in the range 10-99, for example 11,12,13

Now build 3 images. The first parameter is the `id`, the second the size in `GB` the third one an init command to initialize the clusters.

```
INIT="kubeadmin join <various-informations>"
for i in 11 12 13 ; do sh build $i 20 "$INIT" ; done
```

And boot all of them (first paramter is the id, the second is the size of the memory in gb, the thirs is an additional command for the vm installer). Using `--noautoconsole` you start in backgroud.

```
for i in 11 12 13 ; do sh boot.sh $i  --noautoconsole ; done
```

Come back to the master and proceed with the starndard procedure


