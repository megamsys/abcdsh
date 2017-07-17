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


# exit on any error
set -e
echo "update vertice configuration file"
ROOT=$(dirname "${BASH_SOURCE}")
source $ROOT/"../lib/init.sh"
version='1.5.2'

function vertice_usage() {
  echo "Usage:  update-vertice[OPTION]"
  echo
  echo "Options:"
  echo " --gateway-ip  <specify the ip address of vertice gateway> "
  echo "--help"
  echo
}

function update_vertice() {
  if [ -z "$MEGAM_HOME" ]; then
    echo "default Megam Home set /var/lib/megam/"
    MEGAM_HOME="/var/lib/megam/"
  fi
    VERTICE_CONF=$MEGAM_HOME+"vertice/vertice.conf"
    gateway_url=`echo $GATEWAY | sed -e "s/\//\\\\\\\\\//g"`
    if [ ! -f $VERTICE_CONF ]; then
      mkdir -p "${MEGAM_HOME}/vertice"
      wget -O $VERTICE_CONF https://raw.githubusercontent.com/megamsys/vertice/1.5.2/conf/vertice.conf
    fi
    sed -i 's/^[ \t]*api = .*/api = '"${gateway_url}"'/g'  $VERTICE_CONF
    REGION_CONF="${MEGAM_HOME}/region"
    CLUSTER_CONF="${MEGAM_HOME}/cluster"
    echo $REGION >> $REGION_CONF
    count=$(wc -l $REGION_CONF)

    cat $VERTICE_CONF | awk '/one_zone/{c+=1}{if(c=='"${count}"'){sub("one_zone.*","one_zone = \"'"${GATEWAY}"'\"",$0)};print}' >$VERTICE_CONF
    cat $VERTICE_CONF  | awk '/one_datastore_id/{c+=1}{if(c=='"${count}"'){sub("one_datastore_id.*","one_datastore_id = \"'"${DATASTORE_ID}"'\"",$0)};print}' >$VERTICE_CONF
    cat $VERTICE_CONF  | awk '/cluster_id/{c+=1}{if(c=='"${count}"'){sub("cluster_id.*","cluster_id = \"'"${CLUSTER_ID}"'\"",$0)};print}' >$VERTICE_CONF

    if [ ! -z $PUBLIC_IPV4 ]; then
      cat $VERTICE_CONF  | awk '/vnet_pub_ipv4/{c+=1}{if(c=='"${count}"'){sub("vnet_pub_ipv4.*","vnet_pub_ipv4 = [\"'"${PUB_IPV4}"'\"]",$0)};print}' >$VERTICE_CONF
    fi
    if [ ! -z $PUBLIC_IPV6 ]; then
      cat $VERTICE_CONF  | awk '/vnet_pub_ipv6/{c+=1}{if(c=='"${count}"'){sub("vnet_pub_ipv6.*","vnet_pub_ipv6 = [\"'"${PUB_IPV6}"'\"]",$0)};print}' >$VERTICE_CONF
    fi
    if [ ! -z $PRIVATE_IPV4 ]; then
      cat $VERTICE_CONF  | awk '/vnet_pri_ipv4/{c+=1}{if(c=='"${count}"'){sub("vnet_pri_ipv4.*","vnet_pri_ipv4 = [\"'"${PRI_IPV4}"'\"]",$0)};print}' >$VERTICE_CONF
    fi
    if [ ! -z $PRIVATE_IPV6 ]; then
      cat $VERTICE_CONF  | awk '/vnet_pri_ipv6/{c+=1}{if(c=='"${count}"'){sub("vnet_pri_ipv6.*","vnet_pri_ipv6 = [\"'"${PRI_IPV6}"'\"]",$0)};print}' >$VERTICE_CONF
    fi
}

#check cluster parameters are present or not
function parse_verticeparams() {
   check_verticeparams "$@"
   while
    (( $# > 0 ))
    do
    token="$1"
    shift
    case "$token" in
      (--gateway-ip)
        GATEWAY="$1"
        if [ -z "$GATEWAY" ]
        then
         vertice_usage
         exit
        fi
        shift
        ;;
      (--region)
        REGION="$1"
        if [-z "$REGION" ]
        then
          vertice_usage
          exit
        fi
        shift
        ;;
      (--cluster-id)
        CLUSTER_ID="$1"
        shift
        ;;
      (--datastore-id)
        DATASTORE_ID="$1"
        shift
        ;;
      (--network-name)
        NETWORK="$1"
        export NETWORK
        shift
        ;;
      (--help|usage)
        vertice_usage
        exit 0
        ;;

      (*)
        vertice_usage
        exit 1
        ;;

    esac
  done
}

#connect  storage to opennebula master
function connect_vertice()
{
parse_verticeparams
update_vertice "$@"
}

connect_vertice "$@"

#check arguments is passed from commandline
function check_verticeparams() {
if [ "$#" -le 0 ]
 then
 echo "NO ARGUMENTS ARE PASSED!!!!!!"
 vertice_usage
exit 0
fi
}
