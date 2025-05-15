resource "aws_iam_role" "pipeline-roles" {
  #for_each = aws_iam_policy.POLICIE_PIPELINE
  for_each = {
    for compilation in var.services : compilation["name"] => compilation
  }
  name = "AWSCodePipelineServiceRole-${var.region}-${each.key}"
  path = "/service-role/"
  managed_policy_arns = [
    #each.value["arn"],
    aws_iam_policy.POLICIE_PIPELINE[each.key].arn,
    "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess",

  ]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"

        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      }
    ]
  })
  tags = {

  }
}

resource "aws_iam_role" "pipeline-roles-terraform" {
  for_each = aws_iam_policy.pipeline-terraform-policies

  name = "AWSCodePipeline-${var.region}-${each.key}"
  path = "/service-role/"
  managed_policy_arns = [
    each.value["arn"],
    "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess",
    "arn:aws:iam::aws:policy/AdministratorAccess",
  ]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"

        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      }
    ]
  })
  tags = {

  }
}



