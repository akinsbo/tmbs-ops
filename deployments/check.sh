DEPLOYMENT=quoting-sponge-monocular-ui

# Check the deployments
kubectl get pods

kubectl describe  $DEPLOYMENT

# Check helm deployments
# Visit the address specified in the Ingress object in your browser e.g http://172.20.123.185
kubectl get svc --namespace default -w $DEPLOYMENT
export SERVICE_IP=$(kubectl get svc --namespace default $DEPLOYMENT --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
echo http://$SERVICE_IP:8080/login

kubectl logs -f $DEPLOYMENT