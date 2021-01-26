argo_folder="./clusters/base/operators/argo"
app_folder="./clusters/overlays/4.5/applications"

oc apply -k "${argo_folder}"

oc apply -k "${app_folder}"
