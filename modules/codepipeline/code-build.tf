#--------------------------
# CodeBuild
#---------------------------

resource "aws_codebuild_project" "code-compilations" {

  for_each = {
    for service in var.services :  service["name"] => service
    if service["type"] == "python"
  }
  name           = each.key
  service_role = "arn:aws:iam::${var.AWS_ACCOUNT_ID}:role/service-role/codebuild-${each.key}-service-role"
  source_version = "refs/heads/${local.ecs-repo-branch-name[var.environment]}"
  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    modes = []
    type = "NO_CACHE"
  }
  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    privileged_mode = true
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type            = "LINUX_CONTAINER"


    environment_variable {
      name  = "CONTAINER_NAME"
      type  = "PLAINTEXT"
      value = each.key
    }

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      type  = "PLAINTEXT"
      value = var.region
    }
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      type  = "PLAINTEXT"
      value = var.AWS_ACCOUNT_ID
    }

    environment_variable {
      name = "IMAGE_REPO_NAME"
      type = "PLAINTEXT"
      value = lower(each.key)
    }

    environment_variable {
      name  = "IMAGE_TAG"
      type  = "PLAINTEXT"
      value = "latest"
    }

    environment_variable {
      name  = "PORT"
      type  = "PLAINTEXT"
      value = each.value["port"]
    }

    /*
    environment_variable {
      name  = "CONFIG_BUCKET"
      type  = "PLAINTEXT"
      value = "${var.app-name}-configfiles-${var.region}-${var.environment}"
    }*/

    environment_variable {
      name  = "GITHUB_NAME"
      type  = "PLAINTEXT"
      value = each.value["git-name"]
    }

    environment_variable {
      name  = "AWS_ENVIRONMENT"
      type  = "PLAINTEXT"
      value = var.environment
    }

    
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }


  source {
    buildspec = file("${path.module}/buildspec.yml")
    git_clone_depth = 1
    insecure_ssl = false
    location        = "https://github.com/KevsAlex/${each.value["git-name"]}.git"

    report_build_status = false
    type                = "GITHUB"

    git_submodules_config {
      fetch_submodules = false
    }

  }

  #vpc_config {
  #  security_group_ids = [aws_security_group.sg-codebuild.id]
  #  subnets = var.private-subnets
  #  vpc_id  = var.vpc-id
  #}

  tags = {}

  depends_on = [aws_iam_role.codebuild-roles]
}







