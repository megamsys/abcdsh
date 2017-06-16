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

function create_net() {
    sed -i "s/IP = 127.0.0.1/IP = $IP/" $ABCD_ROOT/"one/conf/vnet.net"
    sed -i "s/SIZE = 1/SIZE = $SIZE/" $ABCD_ROOT/"one/conf/vnet.net"
    sed -i "s/^GATEWAY = 127.0.0.1$/GATEWAY = $GATEWAY/" $ABCD_ROOT/"one/conf/vnet.net"
    sed -i "s/^NETWORK_MASK = 255.255.255.xxx$/NETWORK_MASK = $NETMASK/" $ABCD_ROOT/"one/conf/vnet.net"
    if [ "$TYPE" == "IP6" ]
    then
    onevnet create $ABCD_ROOT/"one/conf/vnet6.net"
   else
    onevnet create $ABCD_ROOT/"one/conf/vnet.net"
  fi
}
#create network to opennebula master
function create-network() {
 verify-prereqs onevnet
 create_net
 }

function network_usage() {
  echo "Usage:  connectnetwork[OPTION]"
  echo
  echo "Options:"
  echo " --ip  <First IP in the range in dot notation.> "
  echo "--size <give number of ip addresses in this range.>"
  echo "--gateway <give default gateway ip  for the network>"
  echo "--network_mask <give network mask address>"
  echo "--type <If you have IP6 network use this parameter to specify the type of the network.By default the type IP4"
  echo "--help"
  echo
}

#check network parameters are present or not
function parse_networkparams() {
   check_params "$@"
    while
    (( $# > 0 ))
  do
    token="$1"
    shift
    case "$token" in
      (--ip)
         IP="$1"
        if [ -z "$IP" ]
        then
         network_usage
         exit
        fi
        shift
        ;;
      (--size)
        SIZE="$1"
        if [ -z "$SIZE" ]
        then
         network_usage
         exit
        fi
        shift
       ;;
      (--gateway)
         GATEWAY="$1"
         if [ -z "$GATEWAY" ]
         then
          network_usage
          exit
         fi
         shift
        ;;
      (--network_mask)
          NETMASK="$1"
          if [ -z "$NETMASK" ]
          then
           network_usage
           exit
          fi
          shift
         ;;
      (--type)
        if [ "$1" == "IP6" ]
         then
           TYPE="$1"
        fi
         if [ -z "$1" ]
         then
          network_usage
          exit
         fi
         shift
        ;;
      (--help|usage)
        network_usage
        exit 0
        ;;

      (*)
        network_usage
        exit 1
        ;;

    esac
  done
}
