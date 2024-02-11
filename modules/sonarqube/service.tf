resource "aws_ecs_service" "sonarqube_service" {
  name               = "${var.env_id}-sonarqube"
  cluster            = var.cluster_arn
  task_definition    = aws_ecs_task_definition.sonarqube_ecs_task.arn
  launch_type        = "EC2"
  desired_count      = 2

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [ var.security_group ]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.sonarqube_target_group.arn
    container_name   = "sonarqube"
    container_port   = 9000
  }
}