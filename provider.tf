provider "aws" {

  region = "us-west-2"
  default_tags {
    tags = {
      application-name = "terraform-ecs-interview"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    #bucket = "lmk-terraform-dev"
    key    = "terraform-ecs-interview.tfstate"
    region = "us-west-2"
  }

}

