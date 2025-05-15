resource aws_security_group sg-codebuild {
  name        = "codebuild_interview_${var.environment}-sg"
  description = "Allow CODEBUILD access to private subnet"
  vpc_id      = var.vpc-id

  tags = {
    Name = "sgroup_codebuild_${var.environment}"
  }
}

resource "aws_security_group_rule" "allow_all-sg" {
  type              = "egress"
  to_port           = 0
  protocol          = "all"
  from_port         = 0
  security_group_id = aws_security_group.sg-codebuild.id
  cidr_blocks = ["0.0.0.0/0"]
}
