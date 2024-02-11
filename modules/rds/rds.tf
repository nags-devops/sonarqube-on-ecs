resource "aws_secretsmanager_secret" "rds" {
  name                    = "${var.env_id}-db-credentials"
  recovery_window_in_days = 0
}

resource "random_password" "rds-password" {
  length                  = 20
  upper                   = true
  lower                   = true
  numeric                 = true
  special                 = true
}

resource "aws_secretsmanager_secret_version" "rds-credentials" {
  secret_id               = aws_secretsmanager_secret.rds.id
  secret_string           = "{\"username\":\"dbadmin\",\"password\":\"${random_password.rds-password.result}\"}"
}

resource "aws_db_subnet_group" "postgres" {
  name                    = "${var.env_id}-postgres-subnet-group"
  subnet_ids              = var.private_subnets
}

resource "aws_db_instance" "postgres" {
  identifier              = "${var.env_id}-postgres"
  allocated_storage       = "20"
  storage_type            = "gp2"
  engine                  = "postgres"
  engine_version          = "11.21"
  instance_class          = "t3.medium"
  username                = jsondecode(aws_secretsmanager_secret_version.rds-credentials.secret_string)["username"]
  password                = jsondecode(aws_secretsmanager_secret_version.rds-credentials.secret_string)["password"]
  db_subnet_group_name    = aws_db_subnet_group.postgres.name
  storage_encrypted       = true
  kms_key_id              = var.kms_key_id
  multi_az                = true
  vpc_security_group_ids  = [ var.security_group ]
  backup_window           = "05:00-07:00"
  backup_retention_period = 35
  apply_immediately       = "true"
  skip_final_snapshot     = "true"

  depends_on              = [ aws_db_subnet_group.postgres ]
}
