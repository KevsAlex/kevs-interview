#--------------------------
# Pipeline policies
#---------------------------
resource "aws_iam_policy" "POLICIE_PIPELINE" {
  for_each = {
    for compilation in var.services :  compilation.name => compilation
  }

  tags        = {}
  tags_all    = {}
  name        = "AWSCodePipelineServiceRole-${var.region}-${each.key}"
  path        = "/service-role/"
  description = "Policy used in trust relationship with CodePipeline"

  policy = file("${path.module}/pipeline-policie.json")
}

resource "aws_iam_policy" "POLICIE_VPC" {
  for_each = {
    for compilation in var.services :  compilation.name => compilation
  }

  tags        = {}
  tags_all    = {}
  name        = "CodeBuildVpcPolicy-${each.key}-${var.region}"
  path        = "/service-role/"
  description = "Policy used in trust relationship with CodeBuild"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:CreateNetworkInterfacePermission",
          "ec2:CreateNetworkInterface",
          "ec2:DescribeDhcpOptions",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeVpcs"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [

          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:BatchPutCodeCoverages",
        ]
        Resource = [
          "arn:aws:ec2:${var.region}:${var.region}:network-interface/*",
        ]
        Effect    = "Allow"
        Condition = {
          StringEquals = {

            "ec2:Subnet" = [
              "arn:aws:ec2:${var.region}:${var.AWS_ACCOUNT_ID}:subnet/${var.private-subnets[0]}",
              "arn:aws:ec2:${var.region}:${var.AWS_ACCOUNT_ID}:subnet/${var.private-subnets[1]}"
              //"arn:aws:ec2:${var.AWS_DEFAULT_REGION}:${var.AWS_ACCOUNT_ID}:subnet/${var.subnets[2]}",
              //"arn:aws:ec2:${var.AWS_DEFAULT_REGION}:${var.AWS_ACCOUNT_ID}:subnet/${var.subnets[3]}"
            ],
            "ec2:AuthorizedService" : "codebuild.amazonaws.com"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:codecommit:us-east-1:${var.AWS_ACCOUNT_ID}:${each.key}"
        ],
        "Action" : [
          "codecommit:GitPull"
        ]
      },
      {
        "Effect" : "Allow",
        "Resource" : [
          "*"
        ],
        "Action" : [
          "codepipeline:StartPipelineExecution"
        ]
      }

    ]
  })


}

resource "aws_iam_policy" "pipeline-terraform-policies" {
  for_each = {
    for compilation in var.terraform-services :  compilation.name => compilation
  }

  tags        = {}
  tags_all    = {}
  name        = "PipelineRole-${var.region}-${each.key}"
  path        = "/service-role/"
  description = "Policy used in trust relationship with CodePipeline for terraform pipelines"

  policy = file("${path.module}/pipeline-policie.json")
}

data aws_iam_policy ec2fullaccess {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_policy" "CodeBuildBasePolicy" {
  for_each = {
    for compilation in var.services :  compilation.name => compilation
  }

  tags        = {}
  tags_all    = {}
  name        = "CodeBuildBasePolicy-${each.key}-${var.region}"
  path        = "/service-role/"
  description = "Policy used in trust relationship with CodeBuild"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:logs:${var.region}:${var.AWS_ACCOUNT_ID}:log-group:/aws/codebuild/${each.key}",
          "arn:aws:logs:${var.region}:${var.AWS_ACCOUNT_ID}:log-group:/aws/codebuild/${each.key}:*",
          "arn:aws:logs:*:${var.AWS_ACCOUNT_ID}:log-group:*:log-stream:*"
          //"${aws_s3_bucket.omnia-s3-log-bucket.arn}"
        ]
      },
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation"
        ]
        Effect   = "Allow"
        Resource = [
          //"arn:aws:s3:::codepipeline-${var.AWS_DEFAULT_REGION}-*",
          aws_s3_bucket.s3-log-bucket.arn,
          "${aws_s3_bucket.s3-log-bucket.arn}/*"

        ]
      },
      {
        Action = [
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:BatchPutCodeCoverages",
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:logs:*:${var.AWS_ACCOUNT_ID}:log-group:*",
          "arn:aws:codebuild:${var.region}:${var.AWS_ACCOUNT_ID}:report-group/${each.key}-*"
        ]
      },
      {
        Action = [
          "codeartifact:ReadFromRepository",
          "codeartifact:GetAuthorizationToken",
          "sts:GetServiceBearerToken"
        ]
        Effect   = "Allow"
        Resource = [
          "*"
        ]
      },
      {
        Action = [
          "ssm:PutParameter"
        ]
        Effect   = "Allow"
        Resource = [
          "*"
        ]
      }
    ]
  })

}


