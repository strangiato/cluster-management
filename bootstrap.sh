argo_folder="./clusters/base/operators/argocd"
app_of_apps="./clusters/base/applications/applications-app.yaml"

argo_address="argocd-server-argocd.apps.cluster-0183.0183.example.opentlc.com"
cluster_address="default/api-cluster-0183-0183-example-opentlc-com:6443/opentlc-mgr"

# install the argo operator
oc apply -k "${argo_folder}"

# need to configure the git repo tokens

# configure the cluster with argo
argocd login --sso "${argo_address}"
argocd cluster add "${cluster_address}"

# setup the applications folder to bootstrap everything
oc apply -f "${app_of_apps}"


#!/bin/bash

LANG=C
SLEEP_SECONDS=45

echo ""
echo "Creating ArgoCD Project"
# Avoids weird race condition where sometimes two installplans get created
oc new-project argocd
sleep 2

echo ""
echo "Installing Argo CD Operator."

oc apply -k clusters/base/operators/argocd-operator/

echo "Pause $SLEEP_SECONDS seconds for the creation and approval of the InstallPlan."
sleep $SLEEP_SECONDS

oc rollout status deploy/argocd-operator -n argocd

echo "Listing Argo CD CRDs."
oc get crd | grep argo


echo "Deploying Argo CD instance"

oc apply -k argocd/overlays/default

echo "Waiting for Argo CD server to start..."

sleep $SLEEP_SECONDS

oc rollout status deploy/argocd-server -n argocd

echo "Argo CD ready!"