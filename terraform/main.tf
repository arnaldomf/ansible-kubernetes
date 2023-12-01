provider "aws" {
    region = "eu-central-1"
}

data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}

module "controlplane" {
    source = "./modules/node"

    image_id = data.aws_ami.ubuntu.id
    security_group_ids = var.security_group_ids
    role = "controlplane"
    size = var.controlplane_count
    key_name = var.key_name
    instance_type = var.controlplane_instance_type
}

module "nodes" {
    source = "./modules/node"

    image_id = data.aws_ami.ubuntu.id
    security_group_ids = var.security_group_ids
    role = "node"
    size = var.nodes_count
    key_name = var.key_name
    instance_type = var.node_instance_type
}

data "aws_instance" "controlplane" {
    instance_id = module.controlplane.instance_ids[0]
}

module "controlplane_lb" {
    source = "./modules/loadbalancer"
    loadbalancer_name = "controlplane"
    subnet_ids = [ data.aws_instance.controlplane.subnet_id ]
    security_group_ids = var.security_group_ids
    loadbalancer_port = 6443
    vpc_id = var.vpc_id
    instance_ids = module.controlplane.instance_ids
}