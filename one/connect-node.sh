#!/bin/bash


# exit on any error
set -e

source $(dirname $0)/../kube-util.sh

echo "Starting cluster using provider: $KUBERNETES_PROVIDER"

verify-prereqs
kube-up

# skipping validation for now until since machines show up as private IPs
# source $(dirname $0)/validate-cluster.sh

echo "Done"
