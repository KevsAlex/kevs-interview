resource "aws_ecs_service" "ecs-services" {
  for_each                          = {for target in local.task-target :  target["name"] => target}
  name = each.key

  cluster                           = aws_ecs_cluster.ecs.arn
  task_definition                   = "${each.key}:${each.value["task"]["revision"]}"
  desired_count                     = 1
  launch_type                       = "FARGATE"
  health_check_grace_period_seconds = 300

  deployment_controller {
    type = "ECS"
  }
  deployment_circuit_breaker {
    enable   = false
    rollback = false
  }


  load_balancer {
    container_name = each.key

    container_port   = each.value["port"]["port"]
    target_group_arn = each.value["target"]["arn"]
  }

  network_configuration {
    security_groups = [aws_security_group.sg-ecs.id]
    subnets = var.private-subnets
    #Only for public subnets
    assign_public_ip = true
  }

  lifecycle {
    ignore_changes = [
      task_definition
    ]
  }

  depends_on = [aws_ecs_task_definition.task-definitions]

}

resource "aws_appautoscaling_target" autoscale-target {
  for_each           = aws_ecs_service.ecs-services
  service_namespace  = "ecs"
  scalable_dimension = "ecs:service:DesiredCount"
  resource_id        = "service/${aws_ecs_cluster.ecs.name}/${each.value.name}"
  min_capacity       = 1
  max_capacity       = 2
}

resource "aws_appautoscaling_policy" "your_policy" {
  for_each           = aws_appautoscaling_target.autoscale-target
  name               = "cpu-scaling-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = each.value.resource_id
  scalable_dimension = each.value.scalable_dimension
  service_namespace  = "ecs"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    scale_in_cooldown  = 60
    scale_out_cooldown = 30
    target_value       = 50
  }
}
