locals {

  SOURCE = "Source"
  BUILD  = "Build"
  DEPLOY = "Deploy"

  compilation-policies = [
    for compilation in var.services : {
      policies = [
        lookup(
          {for key, value in aws_iam_policy.CodeBuildBasePolicy :  key => value},
          compilation.name,
          "what?")

      ][
      0
      ]
      ecrAccess   = data.aws_iam_policy.ec2fullaccess
      vpc_policie = [
        lookup(
          {for key, value in aws_iam_policy.POLICIE_VPC :  key => value},
          compilation.name,
          "what?")

      ][
      0
      ]
      name = compilation.name
      git-name = compilation.git-name
    }
  ]
}

