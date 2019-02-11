#!/bin/bash
PUB_IP=${1:?external ip}
PUB_PORT=${2:-6443}
if test "$(whoami)" != root
then echo "Please, run me as 'sudo $0 $@'" ; exit 1
fi
echo "*** Waiting for Cloud-Init to finish:"
cloud-init status --wait
export K8S_VERSION="$(kubectl version | base64 | tr -d '\n')"
export WEAVE_URL="https://cloud.weave.works/k8s/net?k8s-version=$K8S_VERSION"
echo "*** Kubernetes Pulling Images:"
kubeadm config images pull
echo "*** Kubernetes Initializing:"
kubeadm init \
--apiserver-advertise-address "0.0.0.0" \
--apiserver-cert-extra-sans "$PUB_IP" \
--apiserver-bind-port "$PUB_PORT" | tee /tmp/kubeadm.log
echo "*** Installing Weave:"
kubectl apply -f "$WEAVE_URL"
echo "*** Waiting for Kubernetes to get ready:"
STATE="NotReady"
while test "$STATE" != "Ready" ; do 
STATE=$(kubectl get node | tail -1 | awk '{print $2}')
echo -n "." ; sleep 1
done
echo ""
grep "kubeadm join" /tmp/kubeadm.log >/etc/kubernetes/kubeadm-join.sh
awk '{ $3 = "'$PUB_IP:$PUB_PORT'"; print }' </etc/kubernetes/kubeadm-join.sh >/etc/kubernetes/kubeadm-join-ext.sh 
echo "*** If you have a private network, add to Cloud-Init for Workers:"
echo "runcmd:"
echo "- $(cat /etc/kubernetes/kubeadm-join.sh)"
echo "*** If you only have a public network, add to Cloud-Init for Workers:"
echo "runcmd:"
echo "- $(cat /etc/kubernetes/kubeadm-join-ext.sh)"
