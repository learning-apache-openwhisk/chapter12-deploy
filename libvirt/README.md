# Installation

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

Edit the `user-data.txt` addming a password (change  the password to your own)

```
chpasswd:
  list:
   - root:Change-me!
```

Now prepare the master, with ID `10` (pick an ID in the range 10-99) and a 20 GB disk:

```
sh build.sh 10 20
```

And boot it, specifingy the ID and the  memory size in GB:

```
sh boot.sh 10 4
```

The VM will boot and peform an initialization so it can take some time.

Wait until  you see:

```
Reached target Cloud-init target.
```

Now note that with ID 10 the VM is available at IP `192.168.122.10`.

You need to setup a forwarding from the IP of your server (that I name `<external-ip>`) to the virtual machine.

Once done, oress enter and login as root. You will be asked to change the password.

Once logged in, provision it with:

```
kube-init <external-ip>
```

At the end it will show the command to join the cluster.

Exit to the server with `control-]`.

Now you can build moore images for the nodes, for example 3:

```
INIT="<the-command-shown>"
for i in 11 12 13
do sh build.sh $i 20 "$INIT" 
done
```

And boot all of them.

```
for i in 11 12 13 
do sh boot.sh $i 2 --noautoconsole 
done
```

Come back to the master:

```
virsh console node10
```

wait until the cluster is ready

```
watch kubectl get nodes
```

You need the external DNS name of your server and your email address to complete.

```
kube-provision <external-dns-name> <your-email-address>
```

Deploy a sample deployment

```
kubectl apply -f /usr/local/etc/sample.yml
```

Wait until the pod `nginx-pod` is ready (it can take a while)

```
kubectl --namespace sample get pod
```




