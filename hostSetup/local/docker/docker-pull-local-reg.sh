# UBUNTU=ubuntu:16.04
# NGINX=nginx:1.13.1
ELASTICSEARCH=docker.elastic.co/elasticsearch/elasticsearch:6.1.3
IMAGE=$ELASTICSEARCH
NAME=elasticsearch:6.1.3
echo "pulling the image to use"
docker pull $IMAGE
echo "taging the image as localhost:5000/$NAME"
docker tag $NAME localhost:5000/$NAME
echo "pushing the image to the local registry runnung at localhost:5000"
docker push localhost:5000/$NAME
curl http://localhost:5000/v2/_catalog
# Uncomment to remove image from local reg
# echo "removing locally cached Image"
# sudo docker image remove $NAME
# sudo docker image remove localhost:5000/$NAME