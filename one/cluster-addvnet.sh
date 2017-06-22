#!/bin/bash


# exit on any error
set -e
echo "===============Add vnet of cluster  from opennebula master=============="
ROOT=$(dirname "${BASH_SOURCE}")
source $ROOT/"../lib/init.sh"
source $ROOT/"create-node.sh"

function addvnet_cluster_usage() {
  echo "Usage:  cluster-addvnet[OPTION]"
  echo
  echo "Options:"
  echo " --cluster_id  <specify the cluster id> "
  echo " --vnet_id  <specify the vnet id> "
  echo " --help"
  echo
}

#check addvnet of cluster parameters are present or not
function parse_addvnet_clusterparams() {
   check_addvnet_params "$@"
    while
    (( $# > 0 ))
    do
    token="$1"
    shift
    case "$token" in
      (--cluster_id)
        CLUSTER_ID="$1"
        if [ -z "$CLUSTER_ID" ]
        then
         addvnet_cluster_usage
         exit
        fi
        shift
        ;;
      (--vnet_id)
        VNET_ID="$1"
        if [ -z "$VNET_ID" ]
        then
         addvnet_cluster_usage
         exit
        fi
        shift
        ;;
      (--help|usage)
        addvnet_cluster_usage
        exit 0
        ;;

      (*)
       addvnet_cluster_usage
        exit 1
        ;;
    esac
  done
}

#check arguments is passed from commandline
function check_addvnet_params() {
if [ "$#" -le 0 ]
 then
 echo "NO ARGUMENTS ARE PASSED!!!!!!"
 addvnet_cluster_usage
exit 0
fi
}

function cluster_addvnet() {
parse_addvnet_clusterparams "$@"
verify-prereqs onecluster
onecluster addvnet $CLUSTER_ID $VNET_ID
}

cluster_addvnet "$@"
