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

#oc apply -k clusters/base/operators/argocd/argocd-operator/
kustomize build clusters/base/operators/argocd/argocd-operator/ | oc apply -f -

echo "Pause $SLEEP_SECONDS seconds for the creation and approval of the InstallPlan."
sleep $SLEEP_SECONDS

oc rollout status deploy/argocd-operator -n argocd

echo "Listing Argo CD CRDs."
oc get crd | grep argo

echo "Deploying Argo CD instance"

# oc apply -k clusters/base/operators/argocd/argocd/
kustomize build clusters/base/operators/argocd/argocd/ | oc apply -f -

echo "Waiting for Argo CD server to start..."

sleep $SLEEP_SECONDS

oc rollout status deploy/argocd-server -n argocd

echo "Argo CD ready!"

echo "Adding initial applications"

oc apply -k clusters/overlays/4.5/applications/
