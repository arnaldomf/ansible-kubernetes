variable "image_id" {
    type = string
    description = "AMI Image ID for the nodes"
}

variable "instance_type" {
    type = string
    description = "the instance type used for the nodes"
}

variable "key_name" {
    type = string
    description = "the ssh key name to log into the instance"
}

variable "role" {
    type = string
    description = "the role of the node on the cluster"
    
    validation {
      condition = contains(["node", "controlplane"], var.role)
      error_message = "the node role must be either node or controlplane"
    }
}

variable "security_group_ids" {
    type = list(string)

    validation {
      condition = length(var.security_group_ids) != 0
      error_message = "security_group_ids cannot be empty"
    }
}

variable "size" {
    type = number

    validation {
      condition = var.size >= 0
      error_message = "size cannot be negative"
    }
}

variable "nodepool" {
  type = string
  default = "default"
}
