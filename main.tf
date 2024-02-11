terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.23.1"
    }
  }
}

provider "aws" {
  region  = var.region
  default_tags {
    tags = {
      CreatedBy = "Nagarajan Ganapathy"
      Purpose   = "SonarQube"
    }
  }
}

module "network" {
  source = "./modules/network"

  env_id              = var.env_id
  region              = var.region
  vpc_cidr            = var.vpc_cidr
}

module "autoscaling" {
  source = "./modules/autoscaling"

  env_id              = var.env_id
  ec2-keypair         = data.aws_key_pair.ec2-keypair
  account_id          = data.aws_caller_identity.current.account_id
  private_subnets     = [ module.network.sb-1-aza-private, module.network.sb-2-azb-private ]
  security_group      = module.network.security-group
}

module "ecs" {
  source = "./modules/ecs"

  env_id              = var.env_id
  autoscaling_group   = module.autoscaling.autoscaling_group
}

module "rds" {
  source = "./modules/rds"

  env_id              = var.env_id
  vpc_cidr            = var.vpc_cidr
  vpc_id              = module.network.vpc_id
  private_subnets     = [ module.network.sb-1-aza-private, module.network.sb-2-azb-private ]
  security_group      = module.network.security-group
  kms_key_id          = module.autoscaling.kms_key_id
}

module "sonarqube" {
  source = "./modules/sonarqube"

  env_id              = var.env_id
  region              = var.region
  account_id          = data.aws_caller_identity.current.account_id
  vpc_id              = module.network.vpc_id
  private_subnets     = [ module.network.sb-1-aza-private, module.network.sb-2-azb-private ]
  security_group      = module.network.security-group
  cluster_arn         = module.ecs.cluster_arn
  jdbcUrl             = module.rds.jdbcUrl
  jdbcUsername        = module.rds.jdbcUsername
  jdbcPassword        = module.rds.jdbcPassword
}