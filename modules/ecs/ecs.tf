
#--------------------------
#  ECS Cluster
#---------------------------
resource "aws_ecs_cluster" ecs {
  name = "${var.app-name}-cluster-${var.environment}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource aws_ecs_cluster_capacity_providers capacity_provider {
  cluster_name = aws_ecs_cluster.ecs.name

  capacity_providers = [
    "FARGATE",
    "FARGATE_SPOT"
  ]

}