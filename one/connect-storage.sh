#!/bin/bash


# exit on any error
set -e
echo "one datastore creation from opennebula master"

ROOT=$(dirname "${BASH_SOURCE}")
source $ROOT/"create-storage.sh"

#connect  storage to opennebula master
function connect_storage() {
parse_storageparams "$@"
create-storage
}

connect_storage "$@"
