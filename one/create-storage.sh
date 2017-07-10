#!/bin/bash

# Copyright 2015 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# A library of helper functions that each provider hosting Kubernetes must implement to use cluster/kube-*.sh scripts.

# exit on any error
set -e

# Use the config file specified in $KUBE_CONFIG_FILE, or default to
# config-default.sh.
ROOT=$(dirname "${BASH_SOURCE}")
source $ROOT/"../lib/init.sh"
source $ABCD_ROOT/"one/create-node.sh"
DS_CONF=""
function create_ds() {
  if [[ $FS == "fs" || $FS == "nfs" ]]
  then
    DS_CONF=$ABCD_ROOT/"one/conf/ds.conf"
    sed -i "s/^BRIDGE_LIST = 127.0.0.1$/BRIDGE_LIST = $NODEIP/" $DS_CONF
    sed -i "s/^NAME = nfs_images$/NAME = $NAME/" $DS_CONF

  elif [ $FS == "lvm" ]
  then
    DS_CONF=$ABCD_ROOT/"one/conf/lvm_ds.conf"
   sed -i "s/^BRIDGE_LIST = 127.0.0.1$/BRIDGE_LIST = $NODEIP/" $DS_CONF
   sed -i "s/^NAME = production$/NAME = $NAME/" $DS_CONF

 else
   DS_CONF=$ABCD_ROOT/"one/conf/ceph_ds.conf"
   sed -i "s/^BRIDGE_LIST = 127.0.0.1$/BRIDGE_LIST = $NODEIP/" $DS_CONF
   sed -i "s/^CEPH_HOST = 127.0.0.1$/CEPH_HOST = $NODEIP/" $DS_CONF
   sed -i "s/^CEPH_SECRET = f6f03141$/CEPH_SECRET = $CEPH_SECRET/" $DS_CONF
   sed -i "s/^NAME = cephds$/NAME = $NAME/" $DS_CONF

 fi
 ds_id=`onedatastore create $DS_CONF`
 ds1_id=`echo "$ds_id" | sed 's/.*: //'`
mkdir -p $ABCD_OUTPUT
cat >$ONE_DS_OUT<< EOF
 $NODEIP:  $ds1_id
EOF
}
#create node to opennebula master
function create-storage() {
 verify-prereqs onedatastore
 create_ds
 }

function storage_usage() {
  echo "Usage:  connectstorage[OPTION]"
  echo
  echo "Options:"
  echo " --nodeip  <give node ipaddress or name> "
  echo "--name <name of the new cluster>"
  echo "--fs <give filesystem datatype like fs, lvm, nfs, ceph>"
  echo "--secret <if you ceph use this parameter and specify the secret key of ceph>"
  echo "--help"
  echo
}

#check host parameters are present or not
function parse_storageparams() {
   check_storageparams "$@"
    while
    (( $# > 0 ))
  do
    token="$1"
    shift
    case "$token" in
      (--nodeip)
        NODEIP="$1"
        if [ -z "$NODEIP" ]
        then
         storage_usage
         exit
        fi
        shift
        ;;
      (--name)
        NAME="$1"
        if [ -z "$NAME" ]
        then
         storage_usage
         exit
        fi
        shift
        ;;

      (--fs)
        FS="$1"
        if [ -z "$FS" ]
        then
         storage_usage
         exit
        fi
        shift
       ;;
      (--secret)
        if [ "$FS" == "ceph" ]
         then
         CEPH_SECRET="$1"
         if [ -z "$CEPH_SECRET" ]
         then
          storage_usage
          exit
         fi
       else
         echo "warning: This parameter is not used for fs, lvm datastore.So skip this parameter"
       fi
         shift
        ;;
      (--help|usage)
        storage_usage
        exit 0
        ;;

      (*)
        storage_usage
        exit 1
        ;;

    esac
  done
}

function check_storageparams() {
if [ "$#" -le 0 ]
 then
 echo "NO ARGUMENTS ARE PASSED!!!!!!"
 storage_usage
exit 0
fi
}
