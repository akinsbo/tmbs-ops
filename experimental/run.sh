# check resources by tag filters
# aws ec2 describe-tags --filters "Name=key,Values=Name" "Name=value,Values=nodes.maryboyecluster.maryboye.org"

# fetch node instance only (displaying other interesting properties)
# aws ec2 describe-instances --filters "Name=tag:Name,Values=nodes.maryboyecluster.maryboye.org" \
# --query 'Reservations[*].Instances[*].[Placement.AvailabilityZone, SecurityGroups.GroupName, State.Name, InstanceId]' \
# --output text

# fetch only instance value
node_instances=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=nodes.maryboyecluster.maryboye.org" \
--query 'Reservations[*].Instances[*].[InstanceId]' \
--output text)

#  backup current shell IFS
bkpIFS="$IFS"
# set IFS delimiter to " "
IFS=' ' read -r -a instance_array <<<$node_instances
echo ${instance_array[@]}    ##Or printf "%s\n" ${array[@]}
# restore shell IFS
IFS="$bkpIFS"
openPort


openPort()){
# open port on each instance for glusterfs
# define ports to open
cidr_ip_range_array=(2222 24007-24008 49152-49251)

for instance_id in "${instance_array[@]}"
do
# Find the security group that is associated with your instance 
aws ec2 describe-instance-attribute \
--instance-id $instance_id \
--attribute groupSet
    # Add the rule to the security group
    for cidr_ip_range in "${cidr_ip_range_array[@]}"
    do
    aws ec2 authorize-security-group-ingress \
    --group-id security_group_id \
    --protocol tcp \
    --port 22 \
    --cidr $cidr_ip_range
    done
done
}
kernel_modules=(dm_snapshot  dm_mirror dm_thin_pool)
for kernel_module in ${kernel_modules[@]}; do
output=$(lsmod | grep $kernel_module)
echo "output = $output"
if $output contains 
done

# get gluster client version, make it as close to gluster server version as possible
glusterfs --version
