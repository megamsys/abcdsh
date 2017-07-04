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
echo "update nilavu configuration file"
ROOT=$(dirname "${BASH_SOURCE}")
source $ROOT/"../lib/init.sh"

function nilavu_usage() {
  echo "Usage:  update-nilavu[OPTION]"
  echo
  echo "Options:"
  echo " --gateway-ip  <specify the ip address of vertice gateway> "
  echo "--help"
  echo
}
function update_net() {
  if [ -z "$MEGAM_HOME" ]; then
    echo "default Megam Home set /var/lib/megam/"
    MEGAM_HOME="/var/lib/megam/"
  fi
    NILAVU_CONF=$MEGAM_HOME+"nilavu.conf"
    gateway_url=`echo $GATEWAY | sed -e "s/\//\\\\\\\\\//g"`
    sed -i 's/^[ \t]*http_api.*/http_api = '"${gateway_url}"'/g'  $NILAVU_CONF
}

#check cluster parameters are present or not
function parse_nilavuparams() {
   check_clusterparams "$@"
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
         nilavu_usage
         exit
        fi
        shift
        ;;
      (--help|usage)
        nilavu_usage
        exit 0
        ;;

      (*)
        nilavu_usage
        exit 1
        ;;

    esac
  done
}


#check arguments is passed from commandline
function check_nilavuparams() {
if [ "$#" -le 0 ]
 then
 echo "NO ARGUMENTS ARE PASSED!!!!!!"
 nilavu_usage
exit 0
fi
}
