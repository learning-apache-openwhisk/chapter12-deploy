#!/bin/bash
source /usr/local/etc/param.sh
if test "$(whoami)" != root
then echo "Please, run me as 'sudo $0 $@'" ; exit 1
fi
cd /etc/kubernetes
if ! test -e rook-operator.yaml
then echo "*** Installing Rook ***"
    curl "$ROOK_URL/operator.yaml" >rook-operator.yaml
    kubectl apply -f rook-operator.yaml
fi
if ! test -e rook-cluster.yaml
then curl "$ROOK_URL/cluster.yaml" >rook-cluster.yaml
    kubectl apply -f rook-cluster.yaml
fi
if ! test -e rook-storageclass.yaml
then curl "$ROOK_URL/storageclass.yaml" | sed -e 's/fstype: xfs/fstype: ext4/' >rook-storageclass.yaml
     kubectl apply -f rook-storageclass.yaml
     kubectl patch storageclass rook-ceph-block \
     -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
fi
if ! test -e /usr/sbin/traefik
then echo "*** Installing Traefik ***"
     curl -L "$TRAEFIK_URL" -o /usr/sbin/traefik
     chmod +x /usr/sbin/traefik
fi
if ! test -e /etc/traefik.toml
then kubectl apply -f /etc/kubernetes/traefik.yml
     export TOKEN=$(kubectl --namespace kube-system get secret -o json |\
jq '.items[]|select(.metadata.name|contains("traefik-ingress-controller"))|.data.token' -r |\
base64 -d)
     export ENDPOINT="`cat /etc/kubernetes/kubeadm-join.sh | awk '/kubeadm/ { print "https://" $3 }'`"
     envsubst </usr/local/etc/traefik.toml >/etc/traefik.toml
     envsubst </usr/local/etc/traefik.service  >/etc/systemd/system/traefik.service
     systemctl enable traefik
     systemctl restart traefik
fi
if test -z "$2"
then echo "HTTPS with Let's encrypt not configured." 
     echo "To configure it, get a domain name and run:"
     echo "acme <your-domain> <your-email>"
else /usr/local/bin/acme-config "$@"
fi
