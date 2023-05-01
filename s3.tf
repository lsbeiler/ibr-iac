resource "aws_s3_bucket" "ibr_bucket" {
  bucket        = "ibr-data-aws"
  provider      = aws.eu-north-1
  force_destroy = false

  acl = "private"

  tags = {
    Name = "ibr-data-aws"
  }
}
