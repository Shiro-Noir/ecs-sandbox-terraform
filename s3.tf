# S3
resource "aws_s3_bucket" "s3" {
  bucket = "ktershi-testbucket"
  tags = {
    Name = "ktershi-testbucket"
  }

  tags_all = {
    Name = "ktershi-testbucket"
  }
}