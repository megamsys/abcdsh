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
source $ROOT/"config-default.sh"

# Verify prereqs on host machine
function verify-prereqs() {
 # Check the Opennebula command-line clients
 one=$1
 for client in $one ;
 do
  if which $client >/dev/null 2>&1; then
    echo "${client} client installed"
  else
    echo "${client}  does not exist"
    echo "The program 'onehost' is currently not installed."
    echo "You can install it by typing:apt install opennebula-tools."
    exit 1
  fi
 done
}
#create node to opennebula master
function createhost() {
 verify-prereqs onehost
 onehost create $HOSTIP --im $HYPERVISOR --vm $HYPERVISOR
}

function host_usage() {
  echo "Usage:  connectnode[OPTION]"
  echo
  echo "Options:"
  echo " --hostip  <give host ipaddress or name> "
  echo "--hypervisor <give hypervisior name like kvm, xen>"
  echo "--help"
  echo
}

#check host parameters are present or not
function parse_hostparams() {
   check_params "$@"
    while
    (( $# > 0 ))
  do
    token="$1"
    shift
    case "$token" in
      (--hostip)
        HOSTIP="$1"
        if [ -z "$HOSTIP" ]
        then
         usage
         exit
        fi
        shift
        ;;
      (--hypervisor)
       if [ -z "$1" ]
       then
         usage
         exit
       fi
       shift
       ;;
      (--help|usage)
        usage
        exit 0
        ;;

      (*)
        usage
        exit 1
        ;;

    esac
  done
}

#check arguments is passed from commandline
function check_params() {
if [ "$#" -le 0 ]
 then
 echo "NO ARGUMENTS ARE PASSED!!!!!!"
 usage
exit 0
fi
}
