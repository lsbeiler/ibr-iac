resource "aws_iam_role" "iam_role" {
  name               = "ec2_s3_interaction"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = aws_iam_role.iam_role.id
  role = aws_iam_role.iam_role.id
}

resource "aws_iam_role_policy" "iam_role_policy" {
  name   = aws_iam_role.iam_role.id
  role   = aws_iam_role.iam_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["arn:aws:s3:::${aws_s3_bucket.ibr_bucket.id}"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": ["arn:aws:s3:::${aws_s3_bucket.ibr_bucket.id}/*"]
    }
  ]
}
EOF
}
