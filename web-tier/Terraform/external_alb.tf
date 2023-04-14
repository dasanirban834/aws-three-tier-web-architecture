resource "aws_lb_target_group" "this_tg" {
  name     = var.TG_conf["name"]
  port     = var.TG_conf["port"]
  protocol = var.TG_conf["protocol"]
  vpc_id   = data.aws_vpc.this_vpc.id
  health_check {
    enabled           = var.TG_conf["enabled"]
    healthy_threshold = var.TG_conf["healthy_threshold"]
    interval          = var.TG_conf["interval"]
    path              = var.TG_conf["path"]
  }
  target_type = var.TG_conf["target_type"]
  tags = {
    Attached_ALB_dns = aws_lb.this_alb.dns_name
  }
}

resource "aws_lb_target_group_attachment" "this_tg_atchmnt" {
  count            = length(var.instance_details)
  target_group_arn = aws_lb_target_group.this_tg.arn
  target_id        = element([for v in aws_instance.instance : v.id], count.index)
  port             = 80
}

resource "aws_lb" "this_alb" {
  name               = var.ALB_conf["name"]
  load_balancer_type = var.ALB_conf["load_balancer_type"]
  ip_address_type    = var.ALB_conf["ip_address_type"]
  internal           = var.ALB_conf["internal"]
  security_groups    = [data.aws_security_group.ext_alb.id]
  subnets            = [data.aws_subnet.web_subnet_1a.id, data.aws_subnet.web_subnet_1b.id]
  tags               = merge(var.alb_tags)
}

resource "aws_lb_listener" "this_alb_lis" {
  for_each = var.Listener_conf
  load_balancer_arn = aws_lb.this_alb.arn
  port              = each.value["port"]
  protocol          = each.value["protocol"]
  default_action {
    type = each.value["type"]
    target_group_arn = aws_lb_target_group.this_tg.arn
  }
}

resource "aws_lb_listener_rule" "this_alb_lis_rule" {
  for_each     = var.Listener_conf
  listener_arn = element([for k, v in aws_lb_listener.this_alb_lis : v.arn], 0)
  priority     = each.value["priority"]
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this_tg.arn
  }
  condition {
    path_pattern {
      values = ["/health"]
    }
  }
}