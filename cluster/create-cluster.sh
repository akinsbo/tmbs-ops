#----------------------------------------------------------------------------------
# export all variables in the env file, then disable the export
#----------------------------------------------------------------------------------
set -o allexport
source .env.sh
set +o allexport
# #----------------------------------------------------------------------------------
# # Create User and Group. Set Group permissions
# #----------------------------------------------------------------------------------
# # create aws group
# aws iam create-group --group-name $GROUP

# aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --group-name $GROUP
# aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonRoute53FullAccess --group-name $GROUP
# aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --group-name $GROUP
# aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/IAMFullAccess --group-name $GROUP
# aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess --group-name $GROUP

# aws iam create-user --user-name $USER

# aws iam add-user-to-group --user-name $USER --group-name $GROUP

# aws iam create-access-key --user-name $USER

# # You should record the SecretAccessKey and AccessKeyID in the returned JSON output, and then use them below:

# # configure the aws client to use your new IAM user
# aws configure           # Use your new access and secret key here
# aws iam list-users      # you should see a list of all your IAM users here

# # Because "aws configure" doesn't export these vars for kops to use, we export them now
# export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
# export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)

# #----------------------------------------------------------------------------------
# # Check your nameserver
# #----------------------------------------------------------------------------------
# dig ns $DOMAIN_NAME

# # You should see something like 
# # ;; ANSWER SECTION:
# # subdomain.example.com.        172800  IN  NS  ns-1.awsdns-1.net.
# # subdomain.example.com.        172800  IN  NS  ns-2.awsdns-2.org.
# # subdomain.example.com.        172800  IN  NS  ns-3.awsdns-3.com.
# # subdomain.example.com.        172800  IN  NS  ns-4.awsdns-4.co.uk.
# #----------------------------------------------------------------------------------
# # Configure cluster state storage
# #----------------------------------------------------------------------------------
# aws s3api create-bucket \
#     --bucket $BUCKET \
#     --create-bucket-configuration LocationConstraint=$REGION
#     # --region $REGION

# # version s3(highly recommended)
# aws s3api put-bucket-versioning --bucket $BUCKET  --versioning-configuration Status=Enabled
# #----------------------------------------------------------------------------------
# # Create cluster state storage
# #----------------------------------------------------------------------------------

# # list available availability zones in the region
# aws ec2 describe-availability-zones --region $REGION

# create ssh key-pair to connect to aws server
aws ec2 create-key-pair --key-name $KEY_PAIR_NAME
aws ec2 describe-key-pairs --key-name $KEY_PAIR_NAME

# preview the cluster
kops create cluster \
    --cloud aws \
    --master-zones $ZONEA,$ZONEB,$ZONEC \
    --master-size t2.micro \
    --zones $ZONEA,$ZONEB,$ZONEC \
    --node-count 2 \
    --node-size t2.nano \
    --topology private \
    --dns-zone $DOMAIN_NAME \
    --networking flannel \
    --cloud-labels "Team=Dev,Owner=Olaolu Akinsete" \
    ${NAME} \

# build the cluster
kops update cluster ${NAME} --yes

# edit cluster variables(if necessary) and update again
# kops edit cluster ${NAME}
# kops update cluster ${NAME} --yes

#----------------------------------------------------------------------------------
# Check cluster
#----------------------------------------------------------------------------------
kubectl get nodes
# check cluster health
kops validate cluster
# check all systems in cluster    
kubectl -n kube-system get po
# #----------------------------------------------------------------------------------
# # Update cluster from modified cluster spec at ~/.kube/config
# #----------------------------------------------------------------------------------
# kops update cluster --name $NAME
