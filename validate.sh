#!/bin/bash

# exit on error
set -e

# validate the manifests
kustomize build manifests/applications 
kustomize build manifests/operator-instances/argocd 
kustomize build manifests/operator-instances/openshift-container-storage-noobaa 
kustomize build manifests/operator-instances/openshift-container-storage-rgw 
kustomize build manifests/operator-instances/openshift-serverless-knative-eventing/overlays/default 
kustomize build manifests/operator-instances/openshift-serverless-knative-eventing/overlays/knative-kafka 
kustomize build manifests/operator-instances/openshift-serverless-knative-serving/overlays/default 
kustomize build manifests/operators/amq-streams-operator 
kustomize build manifests/operators/argocd-operator 
kustomize build manifests/operators/kogito-operator/overlays/1.x 
kustomize build manifests/operators/kogito-operator/overlays/alpha 
kustomize build manifests/operators/ocs 
kustomize build manifests/operators/opendatahub-operator/overlays/beta 
kustomize build manifests/operators/openshift-container-storage-operator 
kustomize build manifests/operators/openshift-pipelines-operator

for i in 4.3 4.4 4.5 4.6 4.7
do
kustomize build manifests/operators/openshift-serverless-operator/overlays/${i}
done

# Validate cluster-overlays
for i in 4.5 4.7
do
  kustomize build cluster-overlays/${i}/applications
  kustomize build cluster-overlays/${i}/operator-instances
  kustomize build cluster-overlays/${i}/operators
done

