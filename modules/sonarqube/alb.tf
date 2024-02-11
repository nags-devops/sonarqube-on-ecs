resource "aws_lb" "sonarqube_alb" {
  name                = "${var.env_id}-alb-sonarqube"
  internal            = true
  load_balancer_type  = "application"
  security_groups     = [ var.security_group ]
  subnets             = var.private_subnets
}

resource "aws_lb_target_group" "sonarqube_target_group" {
  name                = "sonarqube-target-group"
  port                = 80
  protocol            = "HTTP"
  target_type         = "ip"
  vpc_id              = var.vpc_id
}

resource "aws_lb_listener" "sonarqube_alb_listener" {
  load_balancer_arn   = aws_lb.sonarqube_alb.arn
  port                = "80"
  protocol            = "HTTP"
  default_action {
    type              = "forward"
    target_group_arn  = aws_lb_target_group.sonarqube_target_group.arn
  }
}

