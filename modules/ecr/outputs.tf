
output "repositories-created" {
  value = aws_ecr_repository.repositories
}

output "image-created" {
  value = [
  for listener in var.services: {
    listener = listener.name
    port = listener.port
  }
  ]
}
