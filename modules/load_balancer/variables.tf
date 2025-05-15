variable services {
  description = "name and service port are required in a json list"
  type = any

  #default = [
  #  {
  #    name = "some-other-service",
  #    port = 8127
  #  },
  #  {
  #    name = "some-service",
  #    port = 8128
  #  }
#
  #]
}

variable public-subnets {
  description = "public subnets in list"
  type = list(string)
}

variable private-subnets {
  description = "private subnets in list"
  type = list(string)
}

variable load-balancer-name {
  type = string
}

variable vpc-id {
  description = "Where to set load balancer"
  type = string
}

variable environment {
  type = string
}



