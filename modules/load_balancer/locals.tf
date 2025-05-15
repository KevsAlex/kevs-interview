#--------------------------
# Load balancer
#---------------------------
locals {
  //target-groups = aws_lb_target_group.target-groups

  names = [
  for key, value in var.services : [value.name]
  ]

  /*
  targets = [
  for listener in var.services: {
    listener = listener.name
    arn = try(lookup(aws_lb_target_group.target-groups, listener.name, "what?").arn, "")
    port = listener.port
  }
  ]*/
}