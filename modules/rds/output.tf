output "jdbcUrl" {
  value     = aws_db_instance.postgres.endpoint
}

output "jdbcUsername" {
  value     = jsondecode(aws_secretsmanager_secret_version.rds-credentials.secret_string)["username"]
}

output "jdbcPassword" {
  value     = jsondecode(aws_secretsmanager_secret_version.rds-credentials.secret_string)["password"]
  sensitive = true
}