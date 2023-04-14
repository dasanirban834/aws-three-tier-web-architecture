output "availability_zones" {
  value = data.aws_availability_zones.azs.names
}


output "iam_role" {
  value = {
    id               = data.aws_iam_role.role.id
    arn              = data.aws_iam_role.role.arn
    policy           = data.aws_iam_role.role.assume_role_policy
    session_duration = data.aws_iam_role.role.max_session_duration
    path             = data.aws_iam_role.role.path
  }
}

output "keypair_details" {
  value = {
    id          = "${data.aws_key_pair.key.id}"
    arn         = "${data.aws_key_pair.key.arn}"
    key_type    = "${data.aws_key_pair.key.key_type}"
    fingerprint = "${data.aws_key_pair.key.fingerprint}"
  }
}



output "sg_details" {
  value = {
    ids  = "${data.aws_security_group.sg.id}"
    arns = "${data.aws_security_group.sg.arn}"
  }
}
output "mgmt_sg_details" {
  value = data.aws_security_group.mgmt.id
}



output "web_subnet_1a" {
  value = data.aws_subnet.web_subnet_1a.id
}
output "web_subnet_1b" {
  value = data.aws_subnet.web_subnet_1b.id
}


output "NAT" {
  value = {
    private_ip = data.aws_nat_gateway.ngw.private_ip
    public_ip  = data.aws_nat_gateway.ngw.public_ip
  }
}

output "instance_details" {
  value = {
    instance_id = {for k, v in aws_instance.instance : k => v.id}
    arn = {for k, v in aws_instance.instance : k => v.arn}
    public_ip = {for k, v in aws_instance.instance : k => v.public_ip}
    private_ip = {for k, v in aws_instance.instance : k => v.private_ip}
  }
}

output "alb_tg" {
  value = aws_lb_target_group.this_tg.arn
}

output "alb" {
  value = {
    arn = aws_lb.this_alb.arn
    dns_name = aws_lb.this_alb.dns_name
  }
}
