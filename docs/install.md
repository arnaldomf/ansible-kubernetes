## installation guide
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
echo "export VIRTUAL_ENV=$(pwd)/.ansible" >> .envrc
echo "export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" >> .envrc
echo "export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" >> .envrc
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

#### Note on the AWS Credentials

If your intention is configuring pre-existing instances, then your credentials should be linked to a user with `AmazonEC2ReadOnlyAccess` policy.
On the other hand, if you want the kubernetes-bootstrap-kit to create the instances on your behalf than the user must have the `AmazonEC2FullAccess`
policy.

#### testing your dynamic inventory

If you add the tag role=controlplane to your EC2 instances, you can run the command below to test
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
