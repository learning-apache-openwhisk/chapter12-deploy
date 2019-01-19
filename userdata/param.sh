export K8S_VERSION="$(kubectl version | base64 | tr -d '\n')"
export WEAVE_URL="https://cloud.weave.works/k8s/net?k8s-version=$K8S_VERSION"
export TRAEFIK_URL="https://github.com/containous/traefik/releases/download/v1.7.6/traefik_linux-amd64"
export ROOK_URL="https://raw.githubusercontent.com/rook/rook/release-0.9/cluster/examples/kubernetes/ceph"
