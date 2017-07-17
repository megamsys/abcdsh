# abcdsh

The command control for the pods (bunch of sh's)  for the `Onboard Cloud` [project](https://github.com/megamsys/abcd). The control commands are done seamlessly in the UI. These `sh` is bundled in the container.

## Usage

# OpenNebula[ONE] Adapter

### Connect Host to Master

Master refers to ONE Frontend. Host refers to a compute node.

1. To connect a host ip 127.0.0.1 to master using `default:` hypervisor kvm.

```
$ /var/lib/megam/abcdsh/one/connect-node.sh --hostip 127.0.0.1

```

2. To connect a host with ip 127.0.0.1 to master using hypervisor `xen`

```
$ /var/lib/megam/abcdsh/one/connect-node.sh --hostip 127.0.0.1 --hypervisor xen

```

## Create datastore

1. To create a fs datastore in opennebula master

```
$ /var/lib/megam/abcdsh/one/connect-storage.sh --nodeip 127.0.0.1 --name fs_ds --fs fs
```

2. To create a NFS  datastore in opennebula master

```
$ /var/lib/megam/abcdsh/one/connect-storage.sh --nodeip 127.0.0.1  --name nfs_ds --fs nfs
```

3. To create a LVM  datastore in opennebula master  

```
$ /var/lib/megam/abcdsh/one/connect-storage.sh --nodeip 127.0.0.1 --name lvm_ds --fs lvm  
```
4. To create a CEPH  datastore to opennebula master

For ceph datastore add extra parameter `--secret f6f03141-2666` is required.

```
$ /var/lib/megam/abcdsh/one/connect-storage.sh --nodeip 127.0.0.1 --name ceph_ds --fs ceph --secret f6f03141-2666

```

## Create template

1. To create a Template in opennebula master

```
$ /var/lib/megam/abcdsh/one/create_template.sh
```

## Create network

1. To create a Network to opennebula master using `default:` type IP4 .

```
$ /var/lib/megam/abcdsh/one/connect-network.sh --name public-ipv4 --start-ip 192.168.1.2 --size 2 --gateway 192.168.1.1  --network_mask 255.255.255.0
```
2. To create a Network to opennebula master using `default:` type IP6 .

```
$ /var/lib/megam/abcdsh/one/connect-network.sh  --name public-ipv6 --start-ip 6001:f288:aaaa:bbbb::cccc --size 2 --gateway fe80::1 --network_mask 64 --type IP6
```

## Create image

1. To create a Image in opennebula master

```
$ /var/lib/megam/abcdsh/one/connect-image.sh --name ubuntu --image_url https://s3-ap-southeast-1.amazonaws.com/megampub/iso/megam.tar.gz --datastore 192.168.1.100

(or)

$ /var/lib/megam/abcdsh/one/connect-image.sh --name ubuntu --image_url http://archive.ubuntu.com/ubuntu/dists/xenial/main/installer-amd64/current/images/netboot/mini.iso --datastore 192.168.1.100

```

## Create Cluster

1. To create a cluster in opennebula master

```
$ /var/lib/megam/abcdsh/one/create-cluster.sh --cluster_name test --abcd_token u4M4bDqyw12nO2DsoNFSu1R4lae2khtQ6wxbO244dLs --abcd_url https://192.168.1.13:8443/api/v1/namespaces/default/configmaps/one-data
```
2. Add host to cluster in opennebula master

```
$ /var/lib/megam/abcdsh/one/cluster-addhost.sh --cluster_id test --host_id 192.168.1.1
```
3. Add vnet to cluster in opennebula master
```
$ /var/lib/megam/abcdsh/one/cluster-addvnet.sh --cluster_id test --vnet_name public-ipv4
```
4. Add datastore to cluster in opennebula master
```
$ /var/lib/megam/abcdsh/one/cluster-adddatastore.sh --cluster_name test --datastore_ip ceph_ds
```



## Vertice Configuration Update

1. To update vertice configuration file vertice.conf

```
$/var/lib/megam/abcdsh/vertice/connect-vertice.sh --gateway_ip 192.168.1.100 --datastore-id 100 --cluster-id 101 --network_name PRIVATE-IPV4="net0" --network_name  PRIVATE-IPV6="net1" --network_name PUBLIC-IPV4="net2" --network_name  PUBLIC-IPV6="net3" --region  Romania

```


## Nilavu Configuration Update

1. To update api server ip in nilavu.conf
```
$/var/lib/megam/abcdsh/vertice/connect-apiserver.sh --gateway-ip 192.168.1.100

```
