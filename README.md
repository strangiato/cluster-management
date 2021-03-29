# Cluster Bootstrap

This project is still a work in progress.

The intention is that this will allow you to easily bootstrap an ArgoCD instance to a new cluster which will then instantiate several operators on the cluster.

## Components

- AMQ-Streams Operator
- ArgoCD
- Kogito Operator
- OpenShift Container Storage Operator
- OpenDataHub Operator
- OpenShift Pipelines Operator
- OpenShift Serverless Operator

## Prerequisites

In order to bootstrap this repository you must have the following:

- `oc`
- `kustomize`
- Minimum 3 `worker nodes1`

## Bootstrapping a Cluster

Login to your cluster using `oc`.

Clone this repository to your local environment.

Execute the following script:

```sh
./bootstrap.sh
```

Select the version of OCP you will be installing this on.  **At this point in time only a 4.7 instance deployed using RHPDS has been configured and tested.**

The `bootstrap.sh` script will install the ArgoCD Operator, create an ArgoCD application once it is deployed, and bootstrap a set of ArgoCD applications to configure the cluster.

You can login to ArgoCD from the ArgoCD route:

```sh
oc get routes -n argocd
```

Use the OpenShift Login option and sign in with your user credentials.

The cluster may take 10-15 minutes to finish installing and updating.

### Known Issues

The current sync operations may get stuck and fail to deploy all of the components (generally the `cluster-management-operator-resources` app).  To resolve the issue navigate to the ArgoCD Operator page under `Installed Operators` in the ArgoCD namespace.  Under `Application` tab delete the `cluster-management-operator-resouces` application.  ArgoCD should automatically recreate and restart the sync process.

## Accessing Argo using the CLI

To log into ArgoCD using the `argocd` cli tool run the following command:

```sh
argocd login --sso <argocd-route> --grpc-web
```

## Updating the Admin Group

Argo creates two groups in OpenShift to grant access and control inside of ArgoCD.

- argocdadmins
- argocdusers

To add a user to a group run:

```sh
oc adm groups add-users <groupname> <username>
```

Once the user has been added to the group logout of Argo and log back in to apply the updated permissions.

Can you validate that you have the correct permissions by going to `User Info` menu inside of Argo.

## Future Enhacements Opportunties

- Add and test additional OCP versions and platforms
- Add the sealed secrets operator
- Add the ability to deploy from a private repository
- Add automated testing of resouces with CI
