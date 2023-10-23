# ansible-kubernetes
This is a repository I will use to put my Kubernetes playbooks.
Our Kubernetes will run on Amazon EC2, so we are going to use the Ansible's AWS Collection

## setup
For this project, I'm using python venv and direnv to manage the virtual environment.

```bash
sudo apt install python3.11-venv
sudo apt install direnv
```

Add the following line to end of `$HOME/.zshrc` (see more [here](https://direnv.net/docs/hook.html))

```bash
# $HOME/.zshrc
eval "$(direnv hook zsh)"
```

### virtual env
Before isntalling Ansible, we are going to create a virtualenv.

```bash
python3 -m venv .ansible
echo "VIRTUAL_ENV=$(pwd)/.ansible" >> .envrc
echo "PATH_add .ansible/bin" >> .envrc
direnv allow .
```

Or just copy the envrc.example to .envrc making the proper changes.

### installing ansible and the aws collection

```bash
pip install ansible boto3 botocore
ansible-galaxy collection install amazon.aws
```

### dynamic inventory
The configuration of our dynamic inventory can be found in the file `k8s.aws_ec2.yml`.
An example and an explanation of the possible parameters can be found in [ec2 inventory documentation](https://docs.ansible.com/ansible/latest/collections/amazon/aws/aws_ec2_inventory.html)

If you don't make any change, then just follow the instructions below, and it should work.

```bash
mkdir .credentials
# copy the id_rsa used to access your EC2 Instances into .credentials and rename to k8s_id_rsa
ls -l .credentials/k8s_id_rsa
# -rw------- 1 user user 2.6K Oct 23 22:15 .credentials/k8s_id_rsa
```

#### testing your dynamic inventory

If you add the tag role=controleplane to your EC2 instances, you can run the command below to test
your configuration.

```bash
ansible-inventory -i k8s.aws_ec2.yml --graph
# @all:
#   |--@ungrouped:
#   |--@aws_ec2:
#   |  |--10.9.8.7
#   |--@controlplane:
#   |  |--10.9.8.7
```
