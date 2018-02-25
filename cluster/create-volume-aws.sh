set -o allexport
source .env.sh
set +o allexport
aws ec2 create-volume --size 10 --region $REGION --availability-zone $ZONEB --volume-type gp2