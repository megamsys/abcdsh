#!/bin/bash


# exit on any error
set -e
echo "one vnet creation from opennebula master"

ROOT=$(dirname "${BASH_SOURCE}")
source $ROOT/"create-network.sh"

#connect  network to opennebula master
function connect_network() {
parse_networkparams "$@"
create-network
}

connect_network "$@"
