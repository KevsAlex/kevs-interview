output target-port{
  value = local.target-port
}

output ecs-cluster-name{
  value = aws_ecs_cluster.ecs.name
}