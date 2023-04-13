output "endpoint" {
  value = [for k in aws_rds_cluster.cluster : k.endpoint]
}

output "arn" {
  value = [for k in aws_rds_cluster.cluster : k.arn]
}

