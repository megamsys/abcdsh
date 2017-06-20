#!/bin/bash


# exit on any error
set -e
echo "one image creation from opennebula master"

ROOT=$(dirname "${BASH_SOURCE}")
source $ROOT/"create-image.sh"

#connect  image to opennebula master
function connect_image() {
parse_storageparams "$@"
create-image
}

connect_image "$@"
