#--------------------------
# Security group
#---------------------------
resource aws_security_group sg-load-balancer {
  name        = "alb_ecs_${var.environment}_sg"
  description = "Allow ALB access to task"
  vpc_id      = var.vpc-id

  tags = {
    Name = "sgroup_alb_${var.environment}"
  }
}

resource aws_security_group_rule lb-port {
  for_each = {
  for listener in var.services:  listener.name => listener
  }
  type              = "ingress"
  to_port           = each.value["port"]
  protocol          = "tcp"
  from_port         = each.value["port"]
  security_group_id = aws_security_group.sg-load-balancer.id
  cidr_blocks = ["0.0.0.0/0"]
  description = each.key
}

resource aws_security_group_rule service-port-out {

  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  security_group_id = aws_security_group.sg-load-balancer.id
  cidr_blocks = ["0.0.0.0/0"]
  description = "allow all"
}