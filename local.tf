locals {

  terraform-services = [
    {
      name     = "refactor-infra-settings",
      git-name = "refactorinfrasettings"
    }
  ]


  services = [
    {
      name             = "kevs-interview",
      port             = "5000"
      type             = "python"
      git-account-name = "KevsAlex"
      git-name         = "kevin_alexis_meneses_interview-devops"
      type             = "python"


      scale = {
        dev  = local.fargate_task_scale.small
        test = local.fargate_task_scale.small
        prod = local.fargate_task_scale.small
      }

      task_environment = [
        { name = "MONGO_DB_PASSWORD", value = "ssm:${var.environment}/${local.project_name}/MONGO_DB_PASSWORD" },
      ]
    },
  ]
}
