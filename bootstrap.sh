#!/bin/bash

LANG=C
SLEEP_SECONDS=45
VERSION="4.7"

PS3='Select OpenShift Version: '
options=("4.3" "4.4" "4.5" "4.6" "4.7")
select opt in "${options[@]}"
do
    case $opt in
        "4.3")
            VERSION=$opt
            break
            ;;
        "4.4")
            VERSION=$opt
            break
            ;;
        "4.5")
            VERSION=$opt
            break
            ;;
        "4.6")
            VERSION=$opt
            break
            ;;
        "4.7")
            VERSION=$opt
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

echo ""
echo "Creating ArgoCD Project"
# Avoids weird race condition where sometimes two installplans get created
oc new-project argocd
sleep 2

echo ""
echo "Installing Argo CD Operator."

#oc apply -k clusters/base/operators/argocd/argocd-operator/
kustomize build manifests/operators/argocd-operator/ | oc apply -f -

echo "Pause $SLEEP_SECONDS seconds for the creation and approval of the InstallPlan."
sleep $SLEEP_SECONDS

oc rollout status deploy/argocd-operator -n argocd

echo "Listing Argo CD CRDs."
oc get crd | grep argo

echo "Deploying Argo CD instance"

# oc apply -k clusters/base/operators/argocd/argocd/
kustomize build manifests/operator-instances/argocd/ | oc apply -f -

echo "Waiting for Argo CD server to start..."

sleep $SLEEP_SECONDS

oc rollout status deploy/argocd-server -n argocd

echo "Argo CD ready!"

echo "Adding initial applications"

oc apply -k cluster-overlays/${VERSION}/applications/
