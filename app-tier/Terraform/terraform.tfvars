# ########################################################################
# #                                                                      #
# #                 ::  Instance details ::                              #
# #                                                                      #
# ########################################################################

instance_details = {
  App-Server-VM1 = {
    server_category             = "App"
    availability_zone           = "us-east-1a"
    ami                         = "ami-04581fbf744a7d11f"
    instance_type               = "t2.micro"
    associate_public_ip_address = false
    source_dest_check           = true
    root_block_device = {
      "root_block" = {
        volume_size = 8
        volume_type = "gp2"
      }
    }
    ebs_block_device = {}
  },

  App-Server-VM2 = {
    server_category             = "App"
    availability_zone           = "us-east-1b"
    ami                         = "ami-04581fbf744a7d11f"
    instance_type               = "t2.micro"
    associate_public_ip_address = false
    source_dest_check           = true
    root_block_device = {
      "root_block" = {
        volume_size = 8
        volume_type = "gp2"
      }
    }
    ebs_block_device = {}
  }
}

instance_profile = "CustomInstanceprofile"

TG_conf = {
  enabled           = true
  healthy_threshold = "5"
  interval          = "10"
  name              = "TargetGroup-Internal"
  port              = "4000"
  protocol          = "HTTP"
  target_type       = "instance"
  path              = "/health"
}

ALB_conf = {
  internal           = true
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  name               = "ALB-Internal"
}

Listener_conf = {
  "1" = {
    port        = "80"
    priority    = 100
    protocol    = "HTTP"
    type        = "forward"
  }
}