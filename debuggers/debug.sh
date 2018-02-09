POD_NAME=elasticsearchlogging-0
kubectl describe pod $POD_NAME

# NAMESPACE=default-testing
# # delete all deployments
# kubectl delete deployments --all
# kubectl delete namespace $NAMESPACE # this removed the failing pod from the previous release 
