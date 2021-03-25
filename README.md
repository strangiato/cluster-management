# Cluster Bootstrap

This project is still a work in progress.

The intention is that this will allow you to easily bootstrap an ArgoCD instance to a new cluster which will then instantiate several operators on the cluster.

## Components

- AMQ-Streams
- ArgoCD
- OpenShift Container Storage
- OpenDataHub
- OpenShift Pipelines
- OpenShift Serverless

## Prerequisits

In order to bootstrap this repository you must have the following tools installed:

`oc`
`kustomize`

## Bootstrapping a Cluster

Login to your cluster using `oc`.

Execute the following script:

```sh
./bootstrap.sh
```

Select the version of OCP you will be installing this on.  **At this point in time only a 4.7 instance deployed using RHPDS has been configured and tested.**

The script will install the ArgoCD Operator, create an ArgoCD application once it is deployed, and bootstrap a set of ArgoCD applications to configure the cluster.

You can login to ArgoCD from the ArgoCD route:

```sh
oc get routes -n argocd
```

Use the OpenShift Login option and sign in with your user credentials.

The cluster may take 10-15 minutes to finish installing and updating.

### Known Issues

The current sync operations may get stuck and fail to deploy all of the components (generally the `cluster-management-operator-resources` app).  To resolve the issue navigate to the ArgoCD Operator page under `Installed Operators` in the ArgoCD namespace.  Under `Application` tab delete the `cluster-management-operator-resouces` application.  It should automatically recreate and restart the sync process.
