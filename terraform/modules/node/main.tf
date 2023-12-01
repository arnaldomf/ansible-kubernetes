resource "aws_instance" "node" {
    count = var.size

    ami = var.image_id
    instance_type = var.instance_type
    key_name = var.key_name
    vpc_security_group_ids = var.security_group_ids
    source_dest_check = false 

    tags = {
        Name = "${var.role}"
        role = var.role
        nodepool = var.role == "controlplane" ? "controlplane" : var.nodepool
    }
}
