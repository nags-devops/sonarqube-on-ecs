resource "aws_ecs_cluster" "cluster" {
  name = "${var.env_id}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_capacity_provider" "autoscaling" {
  name = "EC2"
  auto_scaling_group_provider {
    auto_scaling_group_arn      = var.autoscaling_group

    managed_scaling {
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 10
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "list" {
  cluster_name = aws_ecs_cluster.cluster.name
  capacity_providers = ["FARGATE","FARGATE_SPOT",aws_ecs_capacity_provider.autoscaling.name]
  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.autoscaling.name
  }
}

resource "aws_iam_service_linked_role" "application_autoscaling" {
  aws_service_name = "ecs.application-autoscaling.amazonaws.com"
}
