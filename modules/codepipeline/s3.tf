#data "aws_s3_bucket" s3-log-bucket {
#  bucket = "codepipeline-log-us-west-2-lmk-dev"
#}

resource "aws_s3_bucket" s3-log-bucket {
  bucket = "codepipeline-log-kevsinterview-${var.region}-${var.environment}"
  #tags = {
  #  Environment = var.environment
  #}
}