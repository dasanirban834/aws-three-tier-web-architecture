subnet_grp_name = "db-subnet-group"

cluster_details = {
  "db_1" = {
    cluster_identifier      = "database1"
    database_name           = "database1"
    engine                  = "aurora-mysql"
    engine_version          = "5.7.mysql_aurora.2.11.2"
    master_username         = "admin"
    master_password         = "Ani#1234"
    backup_retention_period = 1
    apply_immediately       = true
  }
}

cluster_instance_class = "db.t3.small"