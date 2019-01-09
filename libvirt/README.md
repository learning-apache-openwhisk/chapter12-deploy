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

Edit the user data addming a password (change  the password to your own)

```
chpasswd:
  list:
   - root:Change-me!
```


And a `boot.sh` script:

```
```

Now prepare the master:

```
sh build.sh 10 20 user-data.txt
```

And boot it:

```
sh boot.sh 10 4096
```


Wait until 

```
Reached target Cloud-init target.
```

Press enter and login as root. Execute:

```
kube-provision <external-ip>
```

At the end it will show the command to join the cluster.

Do `cp user-data.txt user-data1.txt`. Edit the `user-data.txt` and the command below `runcmd:` (remember you need a prefix `-`).

Now you can build moore images for the nodes, for example 3:


```
sh build.sh 11 10 user-data1.txt
sh build.sh 12 10 user-data1.txt
sh build.sh 13 10 user-data1.txt
```

And boot all of them.

```
for I in 11 12 13 ; do sh boot.sh $I 2048 --noautoconsole ; done
```

Come back to the master:

----
$ virsh 

