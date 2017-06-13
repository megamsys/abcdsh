#!/bin/bash


# exit on any error
set -e
echo "one datastore creation from opennebula master"

ROOT=$(dirname "${BASH_SOURCE}")
source $ROOT/"create-storage.sh"

#connect filesystem storage to opennebula master
function connect_fsstorage() {
parse_storageparams "$@"
create-storage
}

connect_host "$@"
