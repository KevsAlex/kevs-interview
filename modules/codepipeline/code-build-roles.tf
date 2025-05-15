resource "aws_iam_role" "codebuild-roles" {
  for_each = {for target in local.compilation-policies:  target["name"] => target}
  name = "codebuild-${each.key}-service-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"

        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }


    ]
  })
  managed_policy_arns = [
    each.value["policies"]["arn"],
    each.value["ecrAccess"]["arn"],
    each.value["vpc_policie"]["arn"],
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess",

  ]
  path = "/service-role/"

  tags = {

  }
}



resource "aws_iam_role" "terraform-role" {
  name               = "codebuild-terraform-${var.project-name}-service-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"

        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }


    ]
  })
  managed_policy_arns = [

    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess",
    "arn:aws:iam::aws:policy/job-function/SystemAdministrator",
    //TODO : take out this
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]
  path = "/service-role/"

  tags = {

  }
}

