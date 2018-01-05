#!/bin/sh
MINIKUBE_VERSION=v0.24.1
KUBERNETES_VERSION=v1.8.4

commonLinuxSetup(){
echo "=================================="
echo "Installing packages for $2SETUP"
echo "=================================="
## Setup global .gitignore file config
# setup global git config. Copy gitignore into host
cp `dirname $0`/gitignore_global.txt ~/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global
# confirm copy of the global content into gitignore
cat ~/.gitignore_global
curl -LO https://storage.googleapis.com/kubernetes-release/release/$KUBERNETES_VERSION/bin/$1/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/local/bin/kubectl
kubectl version
# install aws
pip install awscli
}

osxInstall() {
echo '------------------------------------------------'
echo 'PLEASE INSTALL DOCKER AND DOCKER-COMPOSE FOR MAC'
echo '------------------------------------------------'
#Install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
##Install curl
brew install curl
#Install minikube
brew cask install minikube
##Install git
echo "Installing git. This maay need user interaction"
curl -LO https://git-scm.com/download/mac
##Install common tool
commonLinuxSetup darwin OSX
#Download and install vm (docker-machine-driver-hyperkit for OSX)
#https://github.com/kubernetes/minikube/blob/master/docs/drivers.md
curl -LO https://storage.googleapis.com/minikube/releases/latest/docker-machine-driver-hyperkit && chmod +x docker-machine-driver-hyperkit && sudo mv docker-machine-driver-hyperkit /usr/local/bin/ && sudo chown root:wheel /usr/local/bin/docker-machine-driver-hyperkit && sudo chmod u+s /usr/local/bin/docker-machine-driver-hyperkit
#Install docker version manager(dvm)
brew update
brew install dvm
#Install kubernetes kops
brew update && brew install kops
minikube version
kvm --version
kops version
}

linuxSetup(){
echo 'installing curl'
sudo apt-get update
sudo apt-get install curl
echo 'installing git'
sudo apt-get update
sudo apt-get install git-all
echo 'installing docker'
bash install-docker/docker.sh
echo 'installing docker-compose'
bash install-docker/docker-compose.sh
echo 'setting up local docker registry at port 5000'
bash install-docker/docker-registry-setup.sh
commonLinuxSetup linux LINUX
###Install minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/$MINIKUBE_VERSION/minikube-$1-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
#Configure prerequisites of KVM
echo 'preparing our system for Kubernetes Virtual Machine (KVM) installation'
# Install libvirt and qemu-kvm on your system, e.g.
# Debian/Ubuntu (for Debian Stretch libvirt-bin it's been replaced with libvirt-clients and libvirt-daemon-system)
sudo apt install libvirt-bin qemu-kvmd
# Add yourself to the libvirtd group (use libvirt group for rpm based distros) so you don't need to sudo
# Debian/Ubuntu (NOTE: For Ubuntu 17.04 change the group to `libvirt`)
sudo usermod -a -G libvirtd $(whoami)
# Update your current session for the group change to take effect
# Debian/Ubuntu (NOTE: For Ubuntu 17.04 change the group to `libvirt`)
newgrp libvirtd
echo 'downloading and installing vm (docker-machine-driver-kvm2 for Linux)'
#https://github.com/kubernetes/minikube/blob/master/docs/drivers.md
curl -LO https://storage.googleapis.com/minikube/releases/latest/docker-machine-driver-kvm2 && chmod +x docker-machine-driver-kvm2 && sudo mv docker-machine-driver-kvm2 /usr/bin/
#Install docker version manager(dvm)
curl -sL https://howtowhale.github.io/dvm/downloads/latest/install.sh | sh
source /home/olaolu/.dvm/dvm.sh
#Install kubernetes kops
curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops-linux-amd64
sudo mv kops-linux-amd64 /usr/local/bin/kops
minikube version
kvm --version
kops version
}

windowsSetup() {
echo "==============================="
echo "Installing packages for WINDOWS"
echo "==============================="
#setup global git config. Copy gitignore into host
copy %~dp0/gitignore_global.txt %USERPROFILE%\.gitignore_global
git config --global core.excludesfile %USERPROFILE%\.gitignore_global
#confirm copy of the global content into gitignore
type ~/.gitignore_global
#Install kubernetes
echo "Download and install minikube from 'https://github.com/kubernetes/minikube/releases/download/$MINIKUBE_VERSION/minikube-windows-amd64.exe'"
echo "if you have curl installed, use this 'curl -LO https://storage.googleapis.com/kubernetes-release/release/$KUBERNETES_VERSION/bin/windows/amd64/kubectl.exe'"
}

#detect ostype and run choose function to run
case "$OSTYPE" in
  solaris*) echo "SOLARIS OS: Not implemented. Edit `dirname $0`/setup.sh to implement" ;;
  darwin*)  osxInstall;;
  linux*)   linuxSetup;;
  bsd*)     echo "BSD OS: Not implemented. Edit `dirname $0`/setup.sh to implement" ;;
  msys*)    windowsSetup ;;
  *)        echo "unknown: $OSTYPE...OS: Not implemented. Edit `dirname $0`/setup.sh to implement" ;;
esac
