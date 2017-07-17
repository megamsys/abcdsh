#!/bin/bash


# exit on any error
set -e
echo "===============Add host of cluster  from opennebula master=============="
ROOT=$(dirname "${BASH_SOURCE}")
source $ROOT/"../lib/init.sh"
source $ROOT/"create-node.sh"

function addhost_cluster_usage() {
  echo "Usage:  cluster-addhost[OPTION]"
  echo
  echo "Options:"
  echo " --cluster_id  <specify the cluster id> "
  echo " --host_id  <specify the host id> "
  echo " --help"
  echo
}

#check host parameters are present or not
function parse_addhost_clusterparams() {
    check_addhost_params "$@"
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
         addhost_cluster_usage
         exit
        fi
        shift
        ;;
      (--host_id)
        HOST_ID="$1"
	echo $1
        if [ -z "$HOST_ID" ]
        then
          echo "hosttttttttttttttttttttt idddddd"
         addhost_cluster_usage
         exit
        fi
        shift
        ;;
      (--help|usage)
        echo "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM"
        addhost_cluster_usage
        exit 0
        ;;

      (*)
        echo "nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn"
        addhost_cluster_usage
        exit 1
        ;;

    esac
  done
}

#check arguments is passed from commandline
function check_addhost_params() {
if [ "$#" -le 0 ]
then
 echo "NO ARGUMENTS ARE PASSED!!!!!!"
 addhost_cluster_usage
exit 0
fi
}

function cluster_addhost() {
echo "adddddddddddddddddddhhhhhhhhhhhhhhhhhossssssssssssssssstttttttttttt"
parse_addhost_clusterparams "$@"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
verify-prereqs onecluster
onecluster addhost  $CLUSTER_ID $HOST_ID
}

cluster_addhost "$@"
