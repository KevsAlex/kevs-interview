#--------------------------
# General variables
#---------------------------
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

variable "environment" {
  description = "can be dev, staging, prod"
}

variable private_subnets {
  description = "array defining private subnets"
}

variable vpc-id {
  description = "vpc id "
}

#--------------------------
#  FROM TFVARS
#---------------------------
variable region {
  description = "type of region. From tfvars"
}

variable codestar-arn {
description = "codestar for bitbucket"
}