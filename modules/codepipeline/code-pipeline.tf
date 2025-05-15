#--------------------------
# Pipelines
#---------------------------

locals {



  ecs-repo-branch-name = {
    dev  = "CRUD-5678"
    test = "qa"
    prod = "main"
  }
}

#--------------------------
# ECS Pipelines
#---------------------------
resource "aws_codepipeline" pipeline {
  #for_each = aws_iam_role.pipeline-roles
  for_each = {
    for service in var.services :  service.name => service if service.type == "python"
  }
  name     = "${each.key}-${var.environment}"
  role_arn = "arn:aws:iam::${var.AWS_ACCOUNT_ID}:role/service-role/AWSCodePipelineServiceRole-${var.region}-${each.key}"
  //each.value.arn

  artifact_store {
    #location = "codepipeline-${var.AWS_DEFAULT_REGION}-518971726053"
    location = aws_s3_bucket.s3-log-bucket.bucket
    type     = "S3"
  }

  stage {
    name = local.SOURCE

    action {

      name = local.SOURCE
      configuration = {
        ConnectionArn        = var.codestar-arn
        FullRepositoryId     = "KevsAlex/kevin_alexis_meneses_interview-devops"
        OutputArtifactFormat = "CODE_ZIP"
        BranchName           = local.ecs-repo-branch-name[var.environment]
      }
      category = "Source"
      owner    = "AWS"
      provider = "CodeStarSourceConnection"
      version  = "1"
      output_artifacts = ["source_output"]

    }
  }

  stage {
    name = local.BUILD

    action {
      name      = local.BUILD
      namespace = "BuildVariables"
      category  = "Build"
      owner     = "AWS"
      provider  = "CodeBuild"
      input_artifacts = [
        "source_output"
      ]
      output_artifacts = [
        "BuildArtifact"
      ]
      version = "1"

      configuration = {
        ProjectName = each.key

      }
    }
  }

  stage {
    name = local.DEPLOY

    action {
      name      = local.DEPLOY
      namespace = "DeployVariables"
      category  = "Deploy"
      owner     = "AWS"
      provider  = "ECS"
      input_artifacts = [
        "BuildArtifact"
      ]
      version = "1"

      configuration = {

        ClusterName = var.ecs-cluster-name
        ServiceName = each.key

      }
    }
  }

  depends_on = [aws_iam_role.pipeline-roles]

}










