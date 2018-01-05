# export all variables in the env file, then disable the export
set -o allexport
source .env.sh
set +o allexport

# create aws group
aws iam create-group --group-name $GROUP

aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --group-name $GROUP
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonRoute53FullAccess --group-name $GROUP
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --group-name $GROUP
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/IAMFullAccess --group-name $GROUP
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess --group-name $GROUP

aws iam create-user --user-name $USER

aws iam add-user-to-group --user-name $USER --group-name $GROUP

aws iam create-access-key --user-name $USER

# You should record the SecretAccessKey and AccessKeyID in the returned JSON output, and then use them below:

# configure the aws client to use your new IAM user
aws configure           # Use your new access and secret key here
aws iam list-users      # you should see a list of all your IAM users here

# Because "aws configure" doesn't export these vars for kops to use, we export them now
export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)