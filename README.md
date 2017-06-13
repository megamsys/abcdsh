# abcdsh

The command control for the pods (bunch of sh's)  for the `Onboard Cloud` [project](https://github.com/megamsys/abcd)

## Usage

## ONE : Connect Node

```
bash /var/lib/megam/abcdsh/one/connect-node.sh --hostip 127.0.0.1

**Default** we use kvm as the supported hypervisor
If you wish to change the hypervisor then use

 `--hypervisor xen` .
bash /var/lib/megam/abcdsh/one/connect-node.sh --hostip 127.0.0.1 --hypervisor xen

```

## ONE : Create Storage


```
**To create a Fs  datastore to opennebula master**

  bash /var/lib/megam/abcdsh/one/connect-storage.sh --nodeip 127.0.0.1 --fs fs

**To create a NFS  datastore to opennebula master**  

  bash /var/lib/megam/abcdsh/one/connect-storage.sh --nodeip 127.0.0.1  --fs nfs

**To create a NFS  datastore to opennebula master**  

  bash /var/lib/one/abcdsh/one/connect-storage.sh --nodeip 127.0.0.1  --fs lvm  

  **To create a CEPH  datastore to opennebula master.**
  If you use ceph datastore add extra parameter

   `--secret f6f03141-2666`  

  bash /var/lib/one/abcdsh/one/connect-storage.sh --nodeip 127.0.0.1  --fs ceph --secret f6f03141-2666
  
```
