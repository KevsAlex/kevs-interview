locals {

  names = {for target in var.services :  target.name => target}

  target-port = [
    for key, value in var.target-groups : {
      name   = key
      target = value
      service = lookup(local.names, key, "what?")
    }
  ]

  task-target = [
    for key, value in var.target-groups : {
      name   = key
      target = value
      port = lookup(local.names, key, 80)
      task = lookup(aws_ecs_task_definition.task-definitions, key, "what?")
    }
  ]

}