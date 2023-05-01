locals {
  iam_instance_profile = aws_iam_instance_profile.instance_profile.id
  user_data            = templatefile("startup_script.sh", { S3_NAME = aws_s3_bucket.ibr_bucket.id, S3_REGION = aws_s3_bucket.ibr_bucket.region })
  spot_price           = "0.03"
  instance_type        = "t3.nano"
  volume_size_gb       = 10
  key_name             = "ec2_ssh_key"
}
