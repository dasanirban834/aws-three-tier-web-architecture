locals {
  subnet = [data.aws_subnet.db_subnet_1a.id, data.aws_subnet.db_subnet_1b.id]
}

resource "aws_db_subnet_group" "subnet_grp" {
  name       = var.subnet_grp_name
  subnet_ids = local.subnet
  tags       = var.subnet_grp_tags
}

resource "aws_rds_cluster" "cluster" {
  for_each                = var.cluster_details
  cluster_identifier      = each.value.cluster_identifier
  database_name           = each.value.database_name
  db_subnet_group_name    = aws_db_subnet_group.subnet_grp.name
  engine                  = each.value.engine
  engine_version          = each.value.engine_version
  master_username         = each.value.master_username
  master_password         = each.value.master_password
  backup_retention_period = each.value.backup_retention_period
  apply_immediately       = each.value.apply_immediately
  vpc_security_group_ids  = [data.aws_security_group.sg.id]
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = 2
  identifier         = "instance-${count.index}"
  cluster_identifier = element([for i in aws_rds_cluster.cluster : i.id], 0)
  instance_class     = var.cluster_instance_class
  engine             = element([for i in aws_rds_cluster.cluster : i.engine], 0)
  engine_version     = element([for i in aws_rds_cluster.cluster : i.engine_version_actual], 0)
}