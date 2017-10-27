#!/bin/sh 

DEMO="rhos-vyos-nfv-demo"
SRC_DIR=.
AUTHORS="Darin Sorrentino"
PROJECT="https://github.com/redhatdemocentral/rhos-vyos-nfv-demo"
PRODUCT="Red Hat OpenStack NFV Demo"
ANSIBLE_DIR=./ansible
PLAYBOOK=create_vyos_demo.yaml
GIT_REPO=https://github.com/redhatdemocentral
VERSION=1.0

# wipe screen.
clear 

echo
echo "##################################################################"
echo "##                                                              ##"   
echo "##  Setting up the ${DEMO}                           ##"
echo "##                                                              ##"   
echo "##                                                              ##"   
echo "##      ####  ##### #   #  ###                                  ##"
echo "##      #   # #     ## ## #   #                                 ##"
echo "##      #   # ###   # # # #   #                                 ##"
echo "##      #   # #     #   # #   #                                 ##"
echo "##      ####  ####  #   #  ###                                  ##"
echo "##                                                              ##"   
echo "##                                                              ##"   
echo "##  brought to you by,                                          ##"   
echo "##                     ${AUTHORS}                         ##"
echo "##                                                              ##"   
echo "##  ${PROJECT}     ##"
echo "##                                                              ##"   
echo "##################################################################"
echo

ERRORS=0
# make some checks first before proceeding.	
if [[ -r ${SRC_DIR}/${ANSIBLE_DIR}/${PLAYBOOK} ]]; then
  VYOS_IMAGE=$(grep 'vyos_image: ' ${SRC_DIR}/${ANSIBLE_DIR}/${PLAYBOOK} | grep -o "/.*tgz" | sed 's/^\///g')
  VM_IMAGE=$(grep 'vm_image: ' ${SRC_DIR}/${ANSIBLE_DIR}/${PLAYBOOK} | grep -o "/.*tgz" | sed 's/^\///g')

  if [[ ! -r ${SRC_DIR}/${VYOS_IMAGE} ]]; then
    echo ERROR - Missing VyOS image: ${SRC_DIR}/${VYOS_IMAGE}
    ERRORS=$(( ${ERRORS} + 1 ))
  fi

  if [[ ! -r ${SRC_DIR}/${VM_IMAGE} ]]; then
    echo ERROR - Missing VM image: ${SRC_DIR}/${VM_IMAGE}
    ERRORS=$(( ${ERRORS} + 1 ))
  fi

  if [[ ${ERRORS} -gt 0 ]]; then
    echo Required images are present.
  fi
else
  echo Need to clone ${DEMO} repository from ${GIT_REPO} which contains
  echo the necessary images to perform this demo.
  exit
fi

if [[ -r ${SRC_DIR}/${ANSIBLE_DIR}/variables.yaml ]]; then
  RC_FILE=$(egrep ^cloud_rc_file: ${SRC_DIR}/${ANSIBLE_DIR}/variables.yaml | awk '{print $2}')
  source $RC_FILE
  for NETWORK in $(egrep -o "os_network:.*', " ${SRC_DIR}/${ANSIBLE_DIR}/variables.yaml | awk '{print $2}' | sed "s/[',]//g")
  do
    NETWORK_FOUND=$(openstack network list -c Name -f value | egrep "^${NETWORK}$")
    if [[ -z "${NETWORK_FOUND}" ]]; then
      echo "ERROR - Missing Openstack network: ${NETWORK}"
      ERRORS=$(( ${ERRORS} + 1 ))
    fi
  done
else
  echo Need to clone $DEMO repository from $GIT_REPO which contains
  echo the necessary Ansible files to perform this demo.
  exit
fi

if [[ ${ERRORS} -gt 0 ]]; then
  exit
fi


# Run installer.
echo Product installer running now...
echo

cd ./ansible
ansible-playbook ./create_vyos_demo.yaml

if [ $? -ne 0 ]; then
	echo Error occurred during $PRODUCT installation!
	exit
fi
cd

echo
echo "========================================================================"
echo "=                                                                      ="
echo "=  See README.md for general details to run the various demo cases.    ="
echo "=                                                                      ="
echo "=  $PRODUCT $VERSION $DEMO Setup Complete.   ="
echo "=                                                                      ="
echo "========================================================================"

echo
