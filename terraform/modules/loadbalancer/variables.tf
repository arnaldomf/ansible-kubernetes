variable "loadbalancer_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "loadbalancer_port" {
  type = number
}

variable "vpc_id" {
  type = string
}

variable "instance_ids" {
  type = list(string)
}