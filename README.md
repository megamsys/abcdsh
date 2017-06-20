# abcdsh

The command control for the pods (bunch of sh's)  for the `Onboard Cloud` [project](https://github.com/megamsys/abcd)

## Usage

## ONE : Connect Node

1. To connect a host ip 127.0.0.1 to master using `default:` hypervisor kvm.

```
$ /var/lib/megam/abcdsh/one/connect-node.sh --hostip 127.0.0.1

```

2. To connect a host with ip 127.0.0.1 to master using hypervisor `xen`

```
$ /var/lib/megam/abcdsh/one/connect-node.sh --hostip 127.0.0.1 --hypervisor xen

```

## ONE : Create Storage

1. To create a fs datastore in opennebula master

```
$ /var/lib/megam/abcdsh/one/connect-storage.sh --nodeip 127.0.0.1 --fs fs
```

2. To create a NFS  datastore in opennebula master

```
$ /var/lib/megam/abcdsh/one/connect-storage.sh --nodeip 127.0.0.1  --fs nfs
```

3. To create a LVM  datastore in opennebula master  

```
$ /var/lib/megam/abcdsh/one/connect-storage.sh --nodeip 127.0.0.1  --fs lvm  
```
4. To create a CEPH  datastore to opennebula master

For ceph datastore add extra parameter `--secret f6f03141-2666` is required.

```
$ /var/lib/megam/abcdsh/one/connect-storage.sh --nodeip 127.0.0.1  --fs ceph --secret f6f03141-2666

```

## ONE : Create template

1. To create a Template in opennebula master

```
$ /var/lib/megam/abcdsh/one/create_template.sh
```

## ONE : Create network

1. To create a Network to opennebula master using `default:` type IP4 .

```
$ /var/lib/megam/abcdsh/one/connect-network.sh  --ip 192.168.1.2 --size 2 --gateway 192.168.1.1  --network_mask 255.255.255.0
```
2. To create a Network to opennebula master using `default:` type IP6 .

```
$ /var/lib/megam/abcdsh/one/connect-network.sh  --ip 192.168.1.2 --size 2 --gateway 192.168.1.1  --network_mask 255.255.255.0 --type IP6
```

## ONE : Create image

1. To create a Image in opennebula master

```
$ /var/lib/megam/abcdsh/one/connect-image.sh --name ubuntu --image_url https://s3-ap-southeast-1.amazonaws.com/megampub/iso/megam.tar.gz

(or)

$ /var/lib/megam/abcdsh/one/connect-image.sh --name ubuntu --image_url http://archive.ubuntu.com/ubuntu/dists/xenial/main/installer-amd64/current/images/netboot/mini.iso

```
