#  * list clusters with: kops get cluster
#  * edit this cluster with: kops edit cluster maryboyecluster.maryboye.org
#  * edit your node instance group: kops edit ig --name=maryboyecluster.maryboye.org nodes
#  * edit your master instance group: kops edit ig --name=maryboyecluster.maryboye.org master-eu-west-1a


echo 'fetching nodes'
kubectl get nodes
# echo
# echo 'listing clusters'
# echo
# kubectl list cluster
echo
echo 'checking cluster health (component status)'
kubectl get cs
echo
echo 'check for pods'
kubectl get pods
echo
echo 'check for deployment'
kubectl get deployments
echo
echo 'check current config'
kubectl config view --minify
echo
echo 'cluster info'
kubectl cluster-info
echo 'setting up storage glusterfs'
cd glusterfs/
bash run.sh