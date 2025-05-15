#--------------------------
# General variables
#---------------------------
variable app-name{
  description = "Describe the name of your project, this variable is used for name ecs cluster"
  type        = string
}

variable "region" {
  description = "region name us-east-1"
  type        = string

}

variable environment {
  type = string
}

#--------------------------
# ECS variables
#---------------------------
variable target-groups {
  description = "Target group associated to load balancer"
  type        = any
}

variable services {
  description = "Service name and port in which it will run"
  type = any

  #default = [
  #  {
  #    name = "spring-service-example",
  #    port = 8127
  #  }
  #]
}

#--------------------------
# Network
#---------------------------
variable vpc-id {
  description = "VPC id "
  type        = string
}

variable private-subnets {
  description = "private subnets in list"
  type = list(string)
}


#variable service-security-groups {
#  description = "Security groups"
#  type = list(string)
#}
