variable "alb_tags" {
  description = "provides the tags for ALB"
  type = object({
    Environment = string
    Email = string
    Type = string
    Owner = string
  })
  default = {
    Email = "dasanirban0806@gmail.com"
    Environment = "Production"
    Owner = "Anirban Das"
    Type = "External"
  }
}

variable "instance_tags" {
  description = "provides customized tags"
  type        = object({
    Environment = string
    Email = string
    Layer = string
    Owner = string
  })
  default = {
    Email = "dasanirban0806@gmail.com"
    Environment = "Production"
    Layer = "Web"
    Owner = "Anirban Das"
  }

}

variable "instance_profile" {
  type = string
}

variable "instance_details" {
  description = "Provides requiered information regarding instances"
  type = map(object({

    availability_zone           = string
    ami                         = string
    instance_type               = string
    associate_public_ip_address = bool
    server_category             = string
    source_dest_check           = bool

    root_block_device = map(object({
      volume_size = number
      volume_type = string
    }))
    ebs_block_device = map(object({
      volume_size = number
      volume_type = string
    }))
  }))

}

############### Application Load Balancer Variables################

variable "TG_conf" {
  type = object({
    name              = string
    port              = string
    protocol          = string
    target_type       = string
    enabled           = bool
    healthy_threshold = string
    interval          = string
    path              = string
  })
}

variable "ALB_conf" {
  type = object({
    name               = string
    internal           = bool
    load_balancer_type = string
    ip_address_type    = string
  })
}

variable "Listener_conf" {
  type = map(object({
    port        = string
    protocol    = string
    type        = string
    priority    = number
  }))
}