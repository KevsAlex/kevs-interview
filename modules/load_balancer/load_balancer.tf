#--------------------------
# Load balancer
#---------------------------
/*
resource "aws_lb" "load-balancer" {
  name               = "${var.load-balancer-name}-alb-ecs"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg-load-balancer.id]
  subnets            = var.private-subnets

  //TODO : CHANGE it for TRUE XD
  enable_deletion_protection = false

  #ccess_logs {
  # bucket  = aws_s3_bucket.lb_logs.id
  # prefix  = "test-lb"
  # enabled = true
  #

  tags = {
    Environment = var.environment
  }
}

resource "aws_lb_listener" "listeners" {
  for_each          = {for target in local.targets :  target["listener"] => target}
  load_balancer_arn = aws_lb.load-balancer.arn
  port              = each.value["port"]

  protocol = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = each.value["arn"]
  }

  depends_on = [aws_lb_target_group.target-groups]
}*/

/*
resource "aws_lb_target_group" "target-groups" {
  for_each = {
    for listener in var.services :  listener.name => listener
  }
  name                          = "${each.key}-tg"
  port                          = 80
  protocol                      = "HTTP"
  vpc_id                        = var.vpc-id
  target_type                   = "ip"
  protocol_version              = "HTTP1"
  tags                          = {}
  tags_all                      = {}
  load_balancing_algorithm_type = "round_robin"

  health_check {
    enabled             = true
    healthy_threshold   = 5
    unhealthy_threshold = 2
    #path                = "/healthCheck"
    path                = "/"
  }
}
*/
