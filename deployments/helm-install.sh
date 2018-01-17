CHART=jenkins
VERSION=0.4.16
#
helm inspect stable/$CHART | more

# check for versions
helm search stable/$CHART --versions


# helm install stable/$CHART --version=$VERSION