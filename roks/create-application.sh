# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# Install MCM Demo App
#
# V1.0 
#
# ©2020 nikh@ch.ibm.com
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[1;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color




# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# Default Values
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
export TEMP_PATH=$TMPDIR
export MCM_USER=admin
export MCM_PWD=passw0rd
export MCM_IMPORT_NAME=local

export OCP_CONSOLE_PREFIX=console-openshift-console


# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# Do Not Edit Below
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
echo "${GREEN}***************************************************************************************************************************************************${NC}"
echo "${GREEN}***************************************************************************************************************************************************${NC}"
echo "${GREEN}***************************************************************************************************************************************************${NC}"
echo "${GREEN}***************************************************************************************************************************************************${NC}"
echo "  "
echo " ${GREEN}Install MCM Demo App${NC}"
echo "  "
echo "${GREEN}***************************************************************************************************************************************************${NC}"
echo "${GREEN}***************************************************************************************************************************************************${NC}"
echo "${GREEN}***************************************************************************************************************************************************${NC}"
echo "  "
echo "  "
echo "  "




# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# GET PARAMETERS
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
echo "---------------------------------------------------------------------------------------------------------------------------"
echo "---------------------------------------------------------------------------------------------------------------------------"
echo " ${BLUE}Input Parameters${NC}"
echo "---------------------------------------------------------------------------------------------------------------------------"


while getopts "d:h:p:u:n:" opt
do
   case "$opt" in
      d ) INPUT_PATH="$OPTARG" ;;
      h ) INPUT_CLUSTER_NAME="$OPTARG" ;;
      n ) INPUT_IMPORT_NAME="$OPTARG" ;;
      p ) INPUT_PWD="$OPTARG" ;;
      u ) INPUT_USER="$OPTARG" ;;
   esac
done


if [[ $INPUT_PWD == "" ]];
then
    echo "    ${RED}ERROR${NC}: Please provide the MCM Password"
    echo "    USAGE: $0 -p <MCM_PASSWORD> -n <MCM_IMPORT_NAME> [-u <MCM_USER>] [-h <CLUSTER_NAME>]  [-d <TEMP_DIRECTORY>] [-s <STORAGE_CLASS_BLOCK>]"
    exit 1
else
  echo "    ${GREEN}Password OK:${NC}                        '$INPUT_PWD'"
  MCM_PWD=$INPUT_PWD
fi

INPUT_IMPORT_NAME=test

if [[ $INPUT_IMPORT_NAME == "" ]];
then
    echo "    ${RED}ERROR${NC}: Please provide the MCM Password"
    echo "    USAGE: $0 -p <MCM_PASSWORD>  -n <MCM_IMPORT_NAME> [-u <MCM_USER>] [-h <CLUSTER_NAME>]  [-d <TEMP_DIRECTORY>] [-s <STORAGE_CLASS_BLOCK>]"
    exit 1
else
  echo "    ${GREEN}Import Name OK:${NC}                     '$INPUT_IMPORT_NAME'"
  MCM_IMPORT_NAME=$INPUT_IMPORT_NAME
fi


if [[ $INPUT_USER == "" ]];          
then
  echo "    ${ORANGE}No User provided, using${NC}             '$MCM_USER'"
else
  echo "    ${GREEN}User OK:${NC}                            '$INPUT_USER'"
  MCM_USER=$INPUT_USER
fi



if [[ ($INPUT_CLUSTER_NAME == "") ]];
then
  echo "    ${ORANGE}No Cluster Name provided${NC}            ${GREEN}will be determined from Cluster${NC}"
else
  echo "    ${GREEN}Cluster OK:${NC}                           '$INPUT_CLUSTER_NAME'"
  CLUSTER_NAME=$INPUT_CLUSTER_NAME
fi




if [[ $INPUT_PATH == "" ]];
then
  echo "    ${ORANGE}No Path provided, using${NC}             '$TEMP_PATH'"
else
  echo "    ${GREEN}Path OK:${NC}                            '$INPUT_PATH'"
  TEMP_PATH=$INPUT_PATH
fi




if [[ ($INPUT_CLUSTER_NAME == "") ]];
then
  echo "  "
  echo "---------------------------------------------------------------------------------------------------------------------------"
  echo " ${BLUE}Determining Cluster FQN${NC}"
    CLUSTER_ROUTE=$(kubectl get routes console -n openshift-console | tail -n 1 2>&1 ) 
    if [[ $CLUSTER_ROUTE =~ "reencrypt" ]];
    then
      CLUSTER_FQDN=$( echo $CLUSTER_ROUTE | awk '{print $2}')
      if [[ $(uname) =~ "Darwin" ]];
      then
          CLUSTER_NAME=$(echo $CLUSTER_FQDN | sed -e "s/$OCP_CONSOLE_PREFIX.//")
      else
          CLUSTER_NAME=$(echo $CLUSTER_FQDN | sed "s/$OCP_CONSOLE_PREFIX.//")
      fi
      echo "    ${GREEN}Cluster FQDN:${NC}                        '$CLUSTER_NAME'"

    else
      echo "    ${RED}Cannot determine Route${NC}"
      echo "    ${ORANGE}Check your Kubernetes Configuration${NC}"
      echo "    ${RED}Aborting${NC}"
      exit 1
    fi
fi
echo "---------------------------------------------------------------------------------------------------------------------------"
echo "---------------------------------------------------------------------------------------------------------------------------"





# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# Define some Stuff
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
export CONSOLE_URL=console-openshift-console.$CLUSTER_NAME

export ENTITLED_REGISTRY=cp.icr.io
export ENTITLED_REGISTRY_USER=ekey

export INSTALL_PATH=$TEMP_PATH/demo-$CLUSTER_NAME

export MCM_SERVER=https://icp-console.$CLUSTER_NAME




# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# PRE-INSTALL CHECKS
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
echo "  "
echo "  "
echo "  "
echo "  "
echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
echo " ${BLUE}Pre-Install Checks${NC}"
echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
echo "----------------------------------------------------------------------------------------------------------------------------------------------------"



echo "    Check if ${BLUE}cloudctl${NC} Command Line Tool is available"

CLOUDCTL_RESOLVE=$(cloudctl 2>&1)

if [[ $CLOUDCTL_RESOLVE =~ "USAGE" ]];
then
  echo "    ${GREEN}OK${NC}"
else 
  echo "    ${RED}ERROR${NC}: cloudctl Command Line Tool does not exist in your Path"
  echo "    Please install from https://icp-console.$CLUSTER_NAME/common-nav/cli?useNav=multicluster-hub-nav-nav"
  echo "     or run"
  echo "    curl -sL https://ibm.biz/idt-installer | bash"
  exit 1
fi



echo "    Check if ${BLUE}OpenShift${NC} is reachable at               $CONSOLE_URL"
PING_RESOLVE=$(ping -c 1 $CONSOLE_URL 2>&1)
if [[ $PING_RESOLVE =~ "cannot resolve" ]];
then
  echo "    ${RED}ERROR${NC}: Cluster '$CLUSTER_NAME' is not reachable"
  exit 1
else 
  echo "    ${GREEN}OK${NC}"
fi



echo "    Check if OpenShift ${BLUE}KUBECONTEXT${NC} is set for        $CLUSTER_NAME"
KUBECTX_RESOLVE=$(kubectl get routes --all-namespaces 2>&1)
if [[ $KUBECTX_RESOLVE =~ $CLUSTER_NAME ]];
then
  echo "    ${GREEN}OK${NC}"
else 
  echo "    ${RED}ERROR${NC}: Please log into  '$CLUSTER_NAME' via the OpenShift web console"
  exit 1
fi



if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
  echo "  "
  echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
  echo " Install MC plugin for cloudctl"
  curl -kLo cloudctl-mc-plugin https://icp-console.test311-a376efc1170b9b8ace6422196c51e491-0001.eu-de.containers.appdomain.cloud:443/rcm/plugins/mc-darwin-amd64
  cloudctl plugin install -f cloudctl-mc-plugin
  cloudctl mc get cluster
fi





echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
echo "----------------------------------------------------------------------------------------------------------------------------------------------------"


echo "  "
echo "  "
echo "  "
echo "  "
echo "${GREEN}----------------------------------------------------------------------------------------------------------------------------------------------------${NC}"
echo "${GREEN}----------------------------------------------------------------------------------------------------------------------------------------------------${NC}"
echo "${GREEN}----------------------------------------------------------------------------------------------------------------------------------------------------${NC}"
echo " ${GREEN}Will be registered in Cluster ${ORANGE}'$CLUSTER_NAME'${NC}"
echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
echo " ${BLUE}Your configuration${NC}"
echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
echo "    ${GREEN}CLUSTER :${NC}             $CLUSTER_NAME"
echo "    ----------------------------------------------------------------------------------------------------------------------------------------------------"
echo "    ${GREEN}IMPORT NAME :${NC}         $MCM_IMPORT_NAME"
echo "    ----------------------------------------------------------------------------------------------------------------------------------------------------"
echo "    ${GREEN}MCM Server:${NC}           $MCM_SERVER"
echo "    ${GREEN}MCM User Name:${NC}        $MCM_USER"
echo "    ${GREEN}MCM User Password:${NC}    ************"
echo "    ----------------------------------------------------------------------------------------------------------------------------------------------------"
echo "    ${GREEN}INSTALL PATH:${NC}         $INSTALL_PATH"
echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
echo "----------------------------------------------------------------------------------------------------------------------------------------------------"


echo "---------------------------------------------------------------------------------------------------------------------------"
echo " Create Install Directory $INSTALL_PATH"

mkdir -p $INSTALL_PATH 
cd $INSTALL_PATH
rm $INSTALL_PATH/*


# MCM login
cloudctl login -a ${MCM_SERVER} --skip-ssl-validation -u ${MCM_USER} -p ${MCM_PWD} -n services

ACCESS_TOKEN="Bearer 306bb70912c2d6ea243d9c74672e7b39440727a0445c64c133364160cc3429ed615eaa95bf07544b66bc41f25e9f5616160778c92c9051ab5561a6886e2b64db29d93c09face19bfba4545b6a74a66cfdc49f559844ad680b252cc0a9d5cf3e8a99f5c491d099b427b49cba5a8863ad7fa8c98f7de8a9e54d19c2232d2f88cd60d6a9bd87be8dc8ade59bc2fb32efb202b89e14661538da797a763445f1c27c5f68144c586764fc45492021ab3dccab08621adf2e6191f3bf13b4450949b773532914a39b20e8304a8743813e72fd906593b893115e87fea346334c6fe46154fbca7c6b2a1a6cb5ff827c50ae0b206103e592f9b176008e36b423c9bf77c45aafe140a118a6a1acf84a57c57bcb015e3617e3d468f2b1a5cd379577b9ea698690182ac7d3400b69f8d6cae49a5c6b853d77a859aac3d6dc62570685218cbf40ab4642f925e0229e90cd4dce0c565e3ca9bdff04803ad21675f36530c3efed5b920372b160551919b9bdc08959bef104857a2b2b7e9d04043968fc2df8aa0f6e60570a6849edee51c07262327f20aa3a2b3e74ea8012be86f354a5bbd5d577f883f501c8f2d9160f5ab849f3fd1050660198b535be6f94864ce81b74ecc2b70595502e02c3b0cd944e0620396fdbde73a08c33711ea74c9f3a0bc99c980fe63b39cb8461c1810dc39dff8294b6a6745bd75e3edaa23f4745c07de9679346adf22"


curl -k -H "Content-Type: application/x-www-form-urlencoded;charset=UTF-8" -d "grant_type=password&username=admin&password=admin&scope=openid" https://https://icp-console.apps.ocp42.tec.uk.ibm.com/idprovider/v1/auth/identitytoken


curl -k -H "Content-Type: application/x-www-form-urlencoded;charset=UTF-8" -d "Authorization: Bearer 306bb70912c2d6ea243d9c74672e7b39440727a0445c64c133364160cc3429ed615eaa95bf07544b66bc41f25e9f5616160778c92c9051ab5561a6886e2b64db29d93c09face19bfba4545b6a74a66cfdc49f559844ad680b252cc0a9d5cf3e8a99f5c491d099b427b49cba5a8863ad7fa8c98f7de8a9e54d19c2232d2f88cd60d6a9bd87be8dc8ade59bc2fb32efb202b89e14661538da797a763445f1c27c5f68144c586764fc45492021ab3dccab08621adf2e6191f3bf13b4450949b773532914a39b20e8304a8743813e72fd906593b893115e87fea346334c6fe46154fbca7c6b2a1a6cb5ff827c50ae0b206103e592f9b176008e36b423c9bf77c45aafe140a118a6a1acf84a57c57bcb015e3617e3d468f2b1a5cd379577b9ea698690182ac7d3400b69f8d6cae49a5c6b853d77a859aac3d6dc62570685218cbf40ab4642f925e0229e90cd4dce0c565e3ca9bdff04803ad21675f36530c3efed5b920372b160551919b9bdc08959bef104857a2b2b7e9d04043968fc2df8aa0f6e60570a6849edee51c07262327f20aa3a2b3e74ea8012be86f354a5bbd5d577f883f501c8f2d9160f5ab849f3fd1050660198b535be6f94864ce81b74ecc2b70595502e02c3b0cd944e0620396fdbde73a08c33711ea74c9f3a0bc99c980fe63b39cb8461c1810dc39dff8294b6a6745bd75e3edaa23f4745c07de9679346adf22" https://icp-console.apps.ocp42.tec.uk.ibm.com:6443/apis/app.k8s.io/v1beta1/namespaces/default/applications


  curl -k -X GET --header "Authorization: $ACCESS_TOKEN" --header 'Content-Type: application/json' https://icp-console.apps.ocp42.tec.uk.ibm.com:6443/apis/app.k8s.io/v1beta1/namespaces/default/applications

  curl -k -X GET --header "Authorization: $ACCESS_TOKEN" --header 'Content-Type: application/json' https://icp-console.apps.ocp42.tec.uk.ibm.com:6443/apis/



curl -k -X GET --header 'Content-Type: application/json' --header 'Accept: application/json' --header "Authorization: Bearer $ACCESS_TOKEN" 'https://icp-console.apps.ocp42.tec.uk.ibm.com:6443/iam-token/apikeys/'
curl -k -X GET --header 'Accept: application/json' --header "Authorization: Bearer $ACCESS_TOKEN" 'https://icp-console.apps.ocp42.tec.uk.ibm.com:6443/apis/app.k8s.io/v1beta1/namespaces/k8s-demo-app/applications/k8s-demo-app'

echo "curl -k -X GET --header 'Accept: application/json' --header 'Authorization: Bearer $ACCESS_TOKEN' 'https://icp-console.apps.ocp42.tec.uk.ibm.com:6443/apis/app.k8s.io/v1beta1/namespaces/k8s-demo-app/applications/k8s-demo-app'"


/app.k8s.io/v1beta1/namespaces/{namespace}/applications

Authorization: Bearer WWGSijnQ9zLcPmH1lQ0UCKix_MNUm4M3b64GVeRbiilc

echo "${GREEN}---------------------------------------------------------------------------------------------------------------------------${NC}"
echo "${GREEN}---------------------------------------------------------------------------------------------------------------------------${NC}"
echo "${RED}Continue Installation with these parameters? [y,N]${NC}"
echo "${GREEN}---------------------------------------------------------------------------------------------------------------------------${NC}"
echo "${GREEN}---------------------------------------------------------------------------------------------------------------------------${NC}"
read -p "[y,N]" DO_COMM
if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
  echo "${GREEN}Continue...${NC}"
else
  echo "${RED}Installation Aborted${NC}"
  exit 2
fi



  echo "   Waiting for 10 seconds before starting to check for Rollout"
  sleep 30

  REG_RESOLVE=$(kubectl get pods -n multicluster-endpoint 2>&1)
  while [[ ($REG_RESOLVE =~ "Error") || ($REG_RESOLVE =~ "Init") || ($REG_RESOLVE =~ "Pending") || ($REG_RESOLVE =~ "CrashLoopBackOff")  ]]; do 
    REG_RESOLVE=$(kubectl get pods -n multicluster-endpoint 2>&1)
    echo "   Waiting for Rollout" && sleep 1; 
  done

echo "${GREEN}***************************************************************************************************************************************************${NC}"
echo "${GREEN}***************************************************************************************************************************************************${NC}"
echo " ${GREEN}DONE${NC}"
echo "${GREEN}***************************************************************************************************************************************************${NC}"
echo "${GREEN}***************************************************************************************************************************************************${NC}"
