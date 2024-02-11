resource "aws_ecs_task_definition" "sonarqube_ecs_task" {
  family                   = "${var.env_id}_sonarqube"
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "4096"
  execution_role_arn       = aws_iam_role.sonarqube_ecs_execution_role.arn
  task_role_arn            = aws_iam_role.sonarqube_ecs_task_role.arn
  requires_compatibilities = ["EC2"]
  container_definitions    = jsonencode([
    {
      name                 = "sonarqube"
      image                = "sonarqube:latest"
      portMappings = [
        {
          containerPort    = 9000
          hostPort         = 9000
        },
      ],
      environment = [
        {
          jdbcUrl          = var.jdbcUrl
          jdbcUsername     = var.jdbcUsername
          jdbcPassword     = var.jdbcPassword

        }
      ],
      essential = true
    },
  ])
}