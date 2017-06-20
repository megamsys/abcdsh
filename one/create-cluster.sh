#!/bin/bash


# exit on any error
set -e
echo "one cluster creation from opennebula master"
ROOT=$(dirname "${BASH_SOURCE}")
source $ROOT/"../lib/init.sh"
source $ROOT/"create-node.sh"

function cluster_usage() {
  echo "Usage:  create-cluster[OPTION]"
  echo
  echo "Options:"
  echo " --cluster_name  <specify the cluster name> "
  echo "--help"
  echo
}

#check cluster parameters are present or not
function parse_clusterparams() {
   check_clusterparams "$@"
    while
    (( $# > 0 ))
    do
    token="$1"
    shift
    case "$token" in
      (--cluster_name)
        CLUSTER_NAME="$1"
        if [ -z "$CLUSTER_NAME" ]
        then
         cluster_usage
         exit
        fi
        shift
        ;;
      (--help|usage)
        cluster_usage
        exit 0
        ;;

      (*)
        cluster_usage
        exit 1
        ;;

    esac
  done
}

#check arguments is passed from commandline
function check_clusterparams() {
if [ "$#" -le 0 ]
 then
 echo "NO ARGUMENTS ARE PASSED!!!!!!"
 cluster_usage
exit 0
fi
}


function cluster_create() {
parse_clusterparams "$@"
verify-prereqs onecluster
onecluster create $CLUSTER_NAME
}

cluster_create "$@"
