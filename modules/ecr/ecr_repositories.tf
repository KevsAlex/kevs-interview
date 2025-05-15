resource aws_ecr_repository repositories {

  for_each = {
  for vm in var.services:  vm.name => vm
  }
  name = lower(each.key)
  image_tag_mutability = "MUTABLE"
  #encryption_configuration {
  #   encryption_type = "AES256"
  #}
  image_scanning_configuration {
    scan_on_push = true
  }
}


