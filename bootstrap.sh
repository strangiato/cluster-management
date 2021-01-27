argo_folder="./clusters/base/operators/argocd"
app_of_apps="./clusters/base/applications/applications-app.yaml"

argo_address="argocd-server-argocd.apps.cluster-0183.0183.example.opentlc.com"
cluster_address="default/api-cluster-0183-0183-example-opentlc-com:6443/opentlc-mgr"

# install the argo operator
oc apply -k "${argo_folder}"

# configure the cluster with argo
argocd login --sso "${argo_address}"
argocd cluster add "${cluster_address}"

# setup the applications folder to bootstrap everything
oc apply -f "${app_of_apps}"
