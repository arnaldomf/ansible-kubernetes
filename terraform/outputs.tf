output "instance_ids" {
  value = module.nodes.instance_ids
}

output "controlplane_loadbalancer_address" {
  value = module.controlplane_lb.load_balancer_address
}