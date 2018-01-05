KUBE_CONFIG_FILE=config-demo
CERTIFICATE_AUTHORITY=`dirname $0`/fake-ca-file
CLIENT_CERTIFICATE=`dirname $0`/fake-cert-file
CLIENT_KEY=`dirname $0`/fake-key-seefile

#minikube start --vm-driver=kvm2

export MINIKUBE_WANTUPDATENOTIFICATION=false
export MINIKUBE_WANTREPORTERRORPROMPT=false
export MINIKUBE_HOME=$HOME
export CHANGE_MINIKUBE_NONE_USER=true
mkdir $HOME/.kube || true
touch $HOME/.kube/config

export KUBECONFIG=$HOME/.kube/config
sudo -E ./minikube start --vm-driver=none

# this for loop waits until kubectl can access the api server that Minikube has created
for i in {1..150}; do # timeout for 5 minutes
   ./kubectl get po &> /dev/null
   if [ $? -ne 1 ]; then
      break
  fi
  sleep 2
done

# kubectl commands are now able to interact with Minikube cluster


#https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/
#add cluster details
kubectl config --kubeconfig=$KUBE_CONFIG_FILE set-cluster development --server=https://1.2.3.4 --certificate-authority=$CERTIFICATE_AUTHORITY
kubectl config --kubeconfig=$KUBE_CONFIG_FILE set-cluster scratch --server=https://5.6.7.8 --insecure-skip-tls-verify

#add user details
kubectl config --kubeconfig=$KUBE_CONFIG_FILE set-credentials developer --client-certificate=$CLIENT_CERTIFICATE --client-key=$CLIENT_KEY
kubectl config --kubeconfig=$KUBE_CONFIG_FILE set-credentials experimenter --username=exp --password=some-password

#add context details
kubectl config --kubeconfig=$KUBE_CONFIG_FILE set-context dev-frontend --cluster=development --namespace=frontend --user=developer
kubectl config --kubeconfig=$KUBE_CONFIG_FILE set-context dev-storage --cluster=development --namespace=storage --user=developer
kubectl config --kubeconfig=$KUBE_CONFIG_FILE set-context exp-scratch --cluster=scratch --namespace=default --user=experimenter

#view updated config file
echo ""
echo "showing updated config file"
kubectl config --kubeconfig=$KUBE_CONFIG_FILE view

#Set the current context
kubectl config --kubeconfig=$KUBE_CONFIG_FILE use-context dev-frontend

#view current context (with minify argument)\
echo ""
echo "showing current context"
kubectl config --kubeconfig=$KUBE_CONFIG_FILE  view --minify

##Uncomment to change the current context, for example, to exp-scratch or dev-storage
#kubectl config --kubeconfig=config-demo use-context exp-scratch
#kubectl config --kubeconfig=config-demo view --minify
#kubectl config --kubeconfig=config-demo use-context dev-storage
#kubectl config --kubeconfig=config-demo view --minify


#set the variable
#save the current host's kubectl conf
export  KUBECONFIG_SAVED=$KUBECONFIG
export  KUBECONFIG=$KUBECONFIG:$KUBE_CONFIG_FILE
echo ""
echo "showing config view"
kubectl config view

#Uncomment to Append $HOME/config
#if [[ "$OSTYPE" == "linux-gnu" || "darwin"]]; then
#export KUBECONFIG=$KUBECONFIG:$HOME/.kube/config
## for windows OS
#elif [[ "$OSTYPE" == "msys" ]]; then
#export KUBECONFIG=$KUBECONFIG:%HOME%/.kube/config
#fi
#kubectl config view

# Add kubectl shell autocompletion
if [[ "$OSTYPE" == "linux-gnu" ]]; then
echo "source <(kubectl completion bash)" >> ~/.bashrc
elif [[ "$OSTYPE" == "darwin" ]]; then
brew install bash-completion@2
#Uncomment if the above does not work
#kubectl completion bash > $(brew --prefix)/etc/bash_completion.d/kubectl
fi

#view cluster info
kubectl cluster-info
kubectl cluster-info dump

# Uncomment to clean up. This will revert to host's default kube config file
#export KUBECONFIG=$KUBECONFIG_SAVED
