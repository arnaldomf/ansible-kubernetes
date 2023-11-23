variable "security_group_ids" {
  type = list(string)
  description = "the list of security groups for the nodes"
}

variable "controlplane_count" {
  type = number
  description = "the number of instances for the controlplane"
}

variable "nodes_count" {
  type = number
  description = "the number of instances for the nodes"
}

variable "key_name" {
  type = string
  description = "the name of the ssh key to be added to the instances"
}

variable "controlplane_instance_type" {
  type = string
  description = "the instance type for the control plane"
}

variable "node_instance_type" {
  type = string
  description = "tye instance type for the node"
}