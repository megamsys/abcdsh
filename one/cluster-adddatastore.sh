#!/bin/bash


# exit on any error
set -e
echo "===============Add datastore of cluster  from opennebula master=============="
ROOT=$(dirname "${BASH_SOURCE}")
source $ROOT/"../lib/init.sh"
source $ROOT/"create-node.sh"

function ds_cluster_usage() {
  echo "Usage:  cluster-adddatastore[OPTION]"
  echo
  echo "Options:"
  echo " --cluster_id  <specify the cluster id> "
  echo " --datastore_id  <specify the datastore id> "
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
      (--cluster_id)
        CLUSTER_ID="$1"
        if [ -z "$CLUSTER_ID" ]
        then
         ds_cluster_usage
         exit
        fi
        shift
        ;;
      (--datastore_id)
        DATASTORE_ID="$1"
        if [ -z "$DATASTORE_ID" ]
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
onecluster adddatastore $CLUSTER_ID $DATASTORE_ID
}

cluster_adddatastore "$@"
