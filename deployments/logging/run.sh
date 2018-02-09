set -o allexport
source .env.sh
set +o allexport
# create EBS volume in aws
aws ec2 create-volume --availability-zone=$VOLUME_ZONE --size=$VOLUME_SIZE --volume-type=$VOLUME_TYPE