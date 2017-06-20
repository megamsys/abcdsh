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
#download image and create image to opennebula
function image_download() {
basename=${IMAGE_URL##*/}
filename=${basename%%.*}
dir=/var/lib/images
mkdir -p $dir/$filename
cd $dir/$filename
wget $IMAGE_URL
tar -zxvf *.tar.gz
rm -rf *.tar.gz
img=$(ls $dir/$filename)
oneimage create -d $ds_id --name $NAME --path $dir/$filename/$img
}

function create_image() {
source  $ABCD_ROOT/"one/conf/result_info.sh"
ds_id=`echo "$ds" | sed 's/.*: //'`
extension=`echo $IMAGE_URL | awk -F'[.]' '{print $(NF-1)"."$NF}'`
if [ "$extension" == "tar.gz" ]
then
  image_download $ds_id
else
oneimage create -d $ds_id --name $NAME --path $IMAGE_URL
fi
}
#create image to opennebula master
function create-image() {
 verify-prereqs oneimage
 create_image
 }

function image_usage() {
  echo "Usage:  connect-image[OPTION]"
  echo
  echo "Options:"
  echo " --name  <give name of the image> "
  echo "--image_url <specify the download url or pathname of image location>"
  echo "--help"
  echo
}

#check image parameters are present or not
function parse_imageparams() {
   check_params "$@"
    while
    (( $# > 0 ))
  do
    token="$1"
    shift
    case "$token" in
      (--name)
        NAME="$1"
        if [ -z "$NAME" ]
        then
         image_usage
         exit
        fi
        shift
        ;;
      (--image_url)
        IMAGE_URL="$1"
        if [ -z "$IMAGE_URL" ]
        then
         image_usage
         exit
        fi
        shift
       ;;
      (--help|usage)
        image_usage
        exit 0
        ;;

      (*)
        image_usage
        exit 1
        ;;

    esac
  done
}
