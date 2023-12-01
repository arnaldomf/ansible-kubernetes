output "load_balancer_address" {
  value = aws_lb.loadbalancer.dns_name
}