resource "aws_lb_target_group" "target_group" {
  name = "${var.loadbalancer_name}-targetgroup"
  port = 6443
  protocol = "TCP"
  vpc_id = var.vpc_id
  preserve_client_ip = true
  target_type = "instance"
  health_check {
    enabled = true
    healthy_threshold = 3
    interval = 10
    port = 6443
    protocol = "TCP"
    timeout = 2
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group_attachment" "target_group_attachment" {
  count = length(var.instance_ids)
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id = var.instance_ids[count.index]
  port = 6443
}

resource "aws_lb" "loadbalancer" {
  name = var.loadbalancer_name
  internal = false
  load_balancer_type = "network"
  subnets = var.subnet_ids
  ip_address_type = "ipv4"
  security_groups = var.security_group_ids
}

resource "aws_lb_listener" "loadbalancer_listener" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port = var.loadbalancer_port
  protocol = "TCP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}