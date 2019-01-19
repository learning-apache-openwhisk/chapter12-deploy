# Prerequisites

A server running Ubuntu Server, currently tested on versions 16.04 LTS and 18.04 LTS.

Prepare the server with:

```
apt-get -y upgrade
sudo apt-get -y install libvirt-bin virtinst cloud-utils rinetd
mkdir /var/lib/libvirt/kube
cd /var/lib/libvirt/kube
curl -L https://learning-apache-openwhisk.github.io/chapter12-deploy/user-data.txt >user-data.txt
curl -L https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-disk1.img >base.img
```

Ensure you have ip forwarding enabled. Edit /etc/sysctl.conf and uncomment the line: `net.ipv4.ip_forward=1` then execute `sysctl -p`.

# Building images

Edit the user data adding a password (change  the password to your own)

```
chpasswd:
  list:
   - root:Change-me!
```

Now prepare the master. Pick an "id" in the range 10 - 99. The `id` will be used as IP and MAC address and to name the Virtual Machine.

You can now build the image specifying the `id` and the size of the disk image in GB.  For example, for `id=10` and 20 GB of disk space:

```
sh build.sh 10 20
```

After building the vm you can boot it, specifying the `id` and the size of the memory in GB too. For example for `id=10` and 4GB of memory:

```
sh boot.sh 10 4
```

Wait until you see the message: 

```
Reached target Cloud-init target.
```

You can now press enter, then login as `ubuntu`. Note it will ask to change password. Once you got the shell, execute:

```
sudo kube-init <your-server-ip>
```

At the end, it will show a snippet you should use to add it to the user-data to join the cluster. It is in the format:

```
runcmd:
- kubeadm join <various informations>
```

You need only the command part starting with `kubeadm join`. Take note. You can exit from the virtual machine and return to the server pressing "Control+]". Save the `kubeadm join` value in variable with:

```
export INIT="kubeadmin join <various-informations>"
```

You need at least 3 workers. Now pick a few more ids in the range 10-99 for the workers, for example 11,12,13.

Now build 3 images with the `build.sh` script. The first parameter is the `id`, the second the size in `GB`, but you can also specify a third one, an init command. Use it to initialize the clusters. Execute:

```
for i in 11 12 13 ; do sh build $i 20 "$INIT" ; done
```

Now boot all of them. Again, the `boot.sh` uses first paramenter as the `id`, second as the size of the memory in Gb, but it also accept a third parameter: options to pass to the boot command. Use this paramenter to put virtual machines in background passing the value `--noautoconsole`:

```
for i in 11 12 13 ; do sh boot.sh $i  --noautoconsole ; done
```

Come back to the master and proceed with the starndard procedure
