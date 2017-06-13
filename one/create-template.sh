#!/bin/bash


# exit on any error
set -e
echo "one template creation from opennebula master"
ROOT=$(dirname "${BASH_SOURCE}")
source $ROOT/"../lib/init.sh"
source $ROOT/"config-default.sh"
source $ROOT/"create-node.sh"

#connect node to opennebula master
function create_Template() {
verify-prereqs onetemplate
onetemplate create  $ABCD_ROOT/"one/conf/megamtemplate.conf"
}

create_Template
