#!/bin/bash


# Copyright <2017> <Megam Systems Authors>

# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
# associated documentation files (the "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all copies or
# substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
# BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
# AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

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
 hid=$(onehost create $HOSTIP --im $HYPERVISOR --vm $HYPERVISOR)
 hid=`echo "$hid" | sed 's/.*: //'`
 cat >>$ONE_HOST_OUT<<EOF
 $HOSTIP: $hid
 EOF
}

function usage() {
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
