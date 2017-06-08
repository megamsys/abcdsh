#!/bin/bash



##########################################################
#
# Common parameters for ONE
#
##########################################################

# Default number of nodes to make. You can change this as needed
NUM_NODES=3

# Range of IPs assigned to pods
NODE_IP_RANGES="10.244.0.0/16"

# IPs used by Kubernetes master
MASTER_IP_RANGE="${MASTER_IP_RANGE:-10.246.0.0/24}"

# Range of IPs assigned by Kubernetes to services
SERVICE_CLUSTER_IP_RANGE="10.244.240.0/20"
