#!/bin/bash


# exit on any error
set -e
#get id from a file using a key $1 is file name $2 is key
function parseId() {
  ID=`cat $1 | grep "$1" | sed 's/.*: //'`
  echo "$ID"
}
