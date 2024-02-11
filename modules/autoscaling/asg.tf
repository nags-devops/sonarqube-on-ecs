resource "aws_autoscaling_group" "asg" {
  name                  = "${var.env_id}-asg"
  desired_capacity      = 2
  min_size              = 1
  max_size              = 2
  launch_template {
    id                  = aws_launch_template.ecs_instance_lt.id
    version             = aws_launch_template.ecs_instance_lt.latest_version
  }
  vpc_zone_identifier   = var.private_subnets
  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}