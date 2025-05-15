/*
output "target-groups" {
  value = aws_lb_target_group.target-groups
}**/

output "network-target-groups" {
  value = aws_lb_target_group.network-target-groups
}

output "network-lb-arn" {
  value = aws_lb.network-balancer.arn
}

output "network_dns_name" {
  value = aws_lb.network-balancer.dns_name
}

