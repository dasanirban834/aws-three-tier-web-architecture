variable "subnet_grp_name" {
  description = "Subnet Group Name of RDS instance"
  type        = string
  default     = ""
}

variable "subnet_grp_tags" {
  type = map(any)
  default = {
    "Name" = "RDS-Subnet-Group"
  }
}

variable "cluster_details" {
  type = map(object({
    cluster_identifier      = string
    database_name           = string
    engine                  = string
    engine_version          = string
    master_username         = string
    master_password         = string
    backup_retention_period = number
    apply_immediately       = bool


  }))

}

variable "cluster_instance_class" {
  type    = string
  default = ""
}