#!/bin/bash


# exit on any error
set -e
echo "===============Add datastore of cluster  from opennebula master=============="
ROOT=$(dirname "${BASH_SOURCE}")
source $ROOT/"../lib/init.sh"
source $ROOT/"create-node.sh"
source $ROOT/"parser.sh"

function ds_cluster_usage() {
  echo "Usage:  cluster-adddatastore[OPTION]"
  echo
  echo "Options:"
  echo " --cluster  <specify the name of the cluster> "
  echo " --datastore  <specify the ip of the datastore> "
  echo " --help"
  echo
}

#check adddatastore of cluster parameters are present or not
function parse_addds_clusterparams() {
   check_addds_params "$@"
    while
    (( $# > 0 ))
    do
    token="$1"
    shift
    case "$token" in
      (--cluster)
        CLUSTER_NAME="$1"
        if [ -z "$CLUSTER_NAME" ]
        then
         ds_cluster_usage
         exit
        fi
        shift
        ;;
      (--datastore)
        DATASTORE_IP="$1"
        if [ -z "$DATASTORE_IP" ]
        then
         ds_cluster_usage
         exit
        fi
        shift
        ;;
      (--help|usage)
        ds_cluster_usage
        exit 0
        ;;

      (*)
       ds_cluster_usage
        exit 1
        ;;
    esac
  done
}

#check arguments is passed from commandline
function check_addds_params() {
if [ "$#" -le 0 ]
 then
 echo "NO ARGUMENTS ARE PASSED!!!!!!"
 ds_cluster_usage
exit 0
fi
}

function cluster_adddatastore() {
parse_addds_clusterparams "$@"
verify-prereqs onecluster
DATASTORE_ID=$(parseId $ONE_DS_OUT $DATASTORE_IP)
CLUSTER_ID=$(parseId $ONE_CLUSTER_OUT $CLUSTER_NAME)
onecluster adddatastore $CLUSTER_ID $DATASTORE_ID
}

cluster_adddatastore "$@"
