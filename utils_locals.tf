locals {

  project_name = "terraform-ecs-interview"

  ecs_parameters = [

  ]

  fargate_task_scale = {

    nano = {
      cpu    = 256,
      memory = 512
    }

    micro = {
      cpu    = 256,
      memory = 1024
    }

    small = {
      cpu    = 512,
      memory = 1024
    }

    medium = {
      cpu    = 1024,
      memory = 2048
    }

    mediumX = {
      cpu    = 2048,
      memory = 2048
    }

  }

}