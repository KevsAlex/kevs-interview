resource "aws_lb" "network-balancer" {
  name     = "${var.load-balancer-name}-network-ecs-lb-${var.environment}"
  internal = false
  load_balancer_type = "network"
  #security_groups    = [aws_security_group.sg-load-balancer.id]
  subnets = ["subnet-0857b79237b1ae50b","subnet-05dfffa58b2ca3656"]#var.private-subnets

  //TODO : CHANGE it for TRUE XD
  enable_deletion_protection = false

  tags = {
    Environment = var.environment
  }

  //depends_on = [aws_lb.load-balancer]
}


resource "aws_lb_target_group" "network-target-groups" {

  for_each = {
    for listener in var.services :  listener.name => listener
  }
  name        = "netlb-${each.key}-tg"
  port        = each.value["port"]
  protocol    = "TCP"
  vpc_id = var.vpc-id
  #target_type = "alb"
  target_type = "ip"

  protocol_version = "HTTP1"
  tags = {}
  tags_all = {}

  #load_balancing_algorithm_type = "round_robin"
  /*
  health_check {
    enabled             = true
    healthy_threshold   = 5
    unhealthy_threshold = 2
    path                = "/"
  }*/

}

resource "aws_lb_listener" "network-listener" {
  for_each          = aws_lb_target_group.network-target-groups
  load_balancer_arn = aws_lb.network-balancer.arn
  port              = each.value.port

  protocol = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = each.value.arn
  }
}



