# Install helm in cluster
helm init
echo "Checking that tiller pod is running"
kubectl get pods -n kube-touch 
# Make sure we get the latest list of charts
helm repo update
# Install nginx-ingress to prepare to serve monocular
helm install stable/nginx-ingress
# Wait for nginx-ingress pod
kubectl get pods --watch
#--------------------------
# Install monocular into the cluster
helm repo add monocular https://kubernetes-helm.github.io/monocular
helm install --name monocular-mbshow monocular/monocular
# Use the Ingress endpoint to access your Monocular instance
# Wait for all pods to be running (this can take a few minutes)
kubectl get pods --watch
kubectl get ingress
