#----------------------------------------------------------------------------------
# export all variables in the env file, then disable the export
#----------------------------------------------------------------------------------
set -o allexport
source .env.sh
set +o allexport
#----------------------------------------------------------------------------------
# Delete cluster
#----------------------------------------------------------------------------------
kops delete cluster --name ${NAME}
kops delete cluster --name ${NAME} --yes