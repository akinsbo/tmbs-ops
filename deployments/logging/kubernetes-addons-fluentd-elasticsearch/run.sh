sudo kubectl apply -f manifest-all.yaml
kubectl get pods -n kube-system
echo "deploy dashboard"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
kubectl proxy

# 