#--------------------------
# Refactor Params
#---------------------------
resource "aws_ssm_parameter" parameters {
  for_each = {
    for parameter in var.parameters :  parameter["name"] => parameter
  }
  description = each.value["description"]
  name        = "/${var.environment}/${var.project-name}/${each.key}"
  type        = each.value["type"]
  value       = "CHANGE ME"
  lifecycle {
    ignore_changes = [
      value,
    ]
  }
}



