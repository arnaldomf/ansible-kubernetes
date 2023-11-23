# ansible

## inventory
We are using dynamic inventory for this project. The configuration for it can be found on [k8s.aws_ec2.yml](../k8s.aws_ec2.yml)

## roles
We are going to organize our project creating multiple roles. All of them are available under the [../roles](../roles/) directory.

### common
Install all requirements to run either the nodes or controlplane. This includes, containerd, runc and cni-plugins.

## playbooks

### create instances and install controlplane, nodes
By running this playbook, you are going to:
- create the controlplane instances
- create the node instances
- run the playbook `install_controlplane.yaml`
- run the playbook `install_node.yaml`

```bash
ansible-playbook create_cluster.yaml -i k8s.aws_ec2.yml \
    -e security_group_ids=$SECURITY_GROUP_ID \
    -e nodes_count=2 -e key_name=$KEY_NAME \
    -e controlplane_instance_type=t2.medium \
    -e node_instance_type=t2.medium
```

As this playbook is idempotent, you can add more nodes by incrementing the **nodes_count** variable.

### install_controlplane
Run the roles needed to install the requirements for the controlplane.

```bash
ansible-playbook install_controlplane.yaml -i k8s.aws_ec2.yml
```

By the end of the process, it will create the file `.credentials/join_command`.

### install_node
Run the roles needed to install the requirements for the nodes.

```bash
ansible-playbook install_node.yaml -i k8s.aws_ec2.yml
```

## Testing the cluster

First, try running a shell within a pod:

```bash
kubectl run my-shell --rm -ti --image ubuntu -- /bin/bash
```

Then, execute the [sonobuoy](https://github.com/vmware-tanzu/sonobuoy) test suit

## facts

### get all the facts

Facts are the information available on the target machine. You can get them by running the module setup as in:

```bash
ansible controlplane -i k8s.aws_ec2.yml -m setup
```
