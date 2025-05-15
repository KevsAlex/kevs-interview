variable "environment" {
  description = "can be dev, staging, prod"
}

variable AWS_ACCOUNT_ID {
  description = "AWS_ACCOUNT_ID"
}

variable region {
  description = "region"
}

variable project-name {
  description = "project-name"
}

variable codestar-arn {
  description = "codestar id number"
  type = string
}

variable terraform-services {
  type    = list(map(string))
  default = [
    {
      name = "image-1234",
      port = 8421
      git-name = "gitname"
    }
  ]
}

variable services {
  type    = any
}

variable "private-subnets" {
  description = "Subredes privadas"
  type        = list(string)
}

variable ecs-cluster-name {
  description = "ecs cluster name"
  type = string
}

variable vpc-id {
  type = string
}

