# Install helm in cluster
helm init
# Make sure we get the latest list of charts
helm repo update
# Install nginx-ingress to prepare to serve monocular
helm install stable/nginx-ingress
# Install monocular into the cluster
helm repo add monocular https://kubernetes-helm.github.io/monocular
helm install monocular/monocular
# Use the Ingress endpoint to access your Monocular instance
# Wait for all pods to be running (this can take a few minutes)
kubectl get pods --watch
kubectl get ingress
# Visit the address specified in the Ingress object in your browser e.g http://172.20.123.185