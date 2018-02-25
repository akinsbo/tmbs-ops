# Note: do not include '.rpm' in the package name
PACKAGE_TO_INSTALL=libvirt-wireshark-4.0.0-1.fc26.x86_64
#  install alien rpm-deb converter
sudo apt-get install alien
# convert rpm to deb
sudo alien $PACKAGE_TO_INSTALL.rpm
# install deb
sudo dpkg -i $PACKAGE_TO_INSTALL.deb