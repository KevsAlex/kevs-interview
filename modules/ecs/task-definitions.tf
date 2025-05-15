#--------------------------
#  Task Definitions
#---------------------------
resource "aws_ecs_task_definition" task-definitions {
  for_each      = {for target in local.target-port :  target["name"] => target}
  family        = each.key
  task_role_arn = aws_iam_role.ecs_tasks_execution_role.arn//"arn:aws:iam::${var.AWS_ACCOUNT_ID}:role/ecsTaskExecutionRole"
  cpu                = "256" # Minimum CPU
  memory             = "512" # Minimum Memory
  container_definitions = jsonencode([
    {
      name         = each.key
      image        = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/${lower(each.key)}:latest"
      cpu          = 256
      memory       = 512
      essential    = true
      portMappings = [
        {
          protocol      = "tcp"
          containerPort = tonumber(each.value["service"]["port"])
          hostPort      = tonumber(each.value["service"]["port"])
        }
      ]
      logConfiguration : {
        logDriver : "awslogs",
        secretOptions : null,
        options : {
          awslogs-group : "/ecs/${each.key}",
          awslogs-region : var.region,
          awslogs-stream-prefix : "ecs"
        }
      }

      environment : [
        //TODO : SET THIS AS AN INPUT
        {
          name : "CONT_NAME",
          value : each.key
        },
        {
          name : "PORT",
          value : each.value["service"]["port"]
        }

      ]

    }
  ])
  requires_compatibilities = [
    "FARGATE"
  ]
  execution_role_arn = aws_iam_role.ecs_tasks_execution_role.arn//"arn:aws:iam::${var.AWS_ACCOUNT_ID}:role/ecsTaskExecutionRole"//var.taskExecutionRole

  network_mode       = "awsvpc"
  tags               = {}

  depends_on = [aws_cloudwatch_log_group.log-groups]
}