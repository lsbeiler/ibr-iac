## Repeating myself several times here, since Terraform does not support referencing the provider (tied to the region) dynamically.

module "spot_us_east_1" {
  source = "./modules/ec2"

  iam_instance_profile = local.iam_instance_profile
  user_data            = local.user_data
  spot_price           = local.spot_price
  instance_type        = local.instance_type
  volume_size_gb       = local.volume_size_gb
  ssh_keypair_name     = local.key_name
  ssh_public_key       = tls_private_key.private_key.public_key_openssh

  providers = {
    aws = aws
  }
}

module "spot_af_south_1" {
  source = "./modules/ec2"

  iam_instance_profile = local.iam_instance_profile
  user_data            = local.user_data
  spot_price           = local.spot_price
  instance_type        = local.instance_type
  volume_size_gb       = local.volume_size_gb
  ssh_keypair_name     = local.key_name
  ssh_public_key       = tls_private_key.private_key.public_key_openssh

  providers = {
    aws = aws.af-south-1
  }
}

module "spot_ap_east_1" {
  source = "./modules/ec2"

  iam_instance_profile = local.iam_instance_profile
  user_data            = local.user_data
  spot_price           = local.spot_price
  instance_type        = local.instance_type
  volume_size_gb       = local.volume_size_gb
  ssh_keypair_name     = local.key_name
  ssh_public_key       = tls_private_key.private_key.public_key_openssh

  providers = {
    aws = aws.ap-east-1
  }
}

module "spot_ap_northeast_1" {
  source = "./modules/ec2"

  iam_instance_profile = local.iam_instance_profile
  user_data            = local.user_data
  spot_price           = local.spot_price
  instance_type        = local.instance_type
  volume_size_gb       = local.volume_size_gb
  ssh_keypair_name     = local.key_name
  ssh_public_key       = tls_private_key.private_key.public_key_openssh

  providers = {
    aws = aws.ap-northeast-1
  }
}

module "spot_ap_northeast_2" {
  source = "./modules/ec2"

  iam_instance_profile = local.iam_instance_profile
  user_data            = local.user_data
  spot_price           = local.spot_price
  instance_type        = local.instance_type
  volume_size_gb       = local.volume_size_gb
  ssh_keypair_name     = local.key_name
  ssh_public_key       = tls_private_key.private_key.public_key_openssh

  providers = {
    aws = aws.ap-northeast-2
  }
}

module "spot_ap_northeast_3" {
  source = "./modules/ec2"

  iam_instance_profile = local.iam_instance_profile
  user_data            = local.user_data
  spot_price           = local.spot_price
  instance_type        = local.instance_type
  volume_size_gb       = local.volume_size_gb
  ssh_keypair_name     = local.key_name
  ssh_public_key       = tls_private_key.private_key.public_key_openssh

  providers = {
    aws = aws.ap-northeast-3
  }
}

module "spot_ap_south_1" {
  source = "./modules/ec2"

  iam_instance_profile = local.iam_instance_profile
  user_data            = local.user_data
  spot_price           = local.spot_price
  instance_type        = local.instance_type
  volume_size_gb       = local.volume_size_gb
  ssh_keypair_name     = local.key_name
  ssh_public_key       = tls_private_key.private_key.public_key_openssh

  providers = {
    aws = aws.ap-south-1
  }
}

module "spot_ap_south_2" {
  source = "./modules/ec2"

  iam_instance_profile = local.iam_instance_profile
  user_data            = local.user_data
  spot_price           = local.spot_price
  instance_type        = local.instance_type
  volume_size_gb       = local.volume_size_gb
  ssh_keypair_name     = local.key_name
  ssh_public_key       = tls_private_key.private_key.public_key_openssh

  providers = {
    aws = aws.ap-south-2
  }
}

module "spot_ap_southeast_1" {
  source = "./modules/ec2"

  iam_instance_profile = local.iam_instance_profile
  user_data            = local.user_data
  spot_price           = local.spot_price
  instance_type        = local.instance_type
  volume_size_gb       = local.volume_size_gb
  ssh_keypair_name     = local.key_name
  ssh_public_key       = tls_private_key.private_key.public_key_openssh

  providers = {
    aws = aws.ap-southeast-1
  }
}

module "spot_ap_southeast_2" {
  source = "./modules/ec2"

  iam_instance_profile = local.iam_instance_profile
  user_data            = local.user_data
  spot_price           = local.spot_price
  instance_type        = local.instance_type
  volume_size_gb       = local.volume_size_gb
  ssh_keypair_name     = local.key_name
  ssh_public_key       = tls_private_key.private_key.public_key_openssh

  providers = {
    aws = aws.ap-southeast-2
  }
}

module "spot_ap_southeast_3" {
  source = "./modules/ec2"

  iam_instance_profile = local.iam_instance_profile
  user_data            = local.user_data
  spot_price           = local.spot_price
  instance_type        = local.instance_type
  volume_size_gb       = local.volume_size_gb
  ssh_keypair_name     = local.key_name
  ssh_public_key       = tls_private_key.private_key.public_key_openssh

  providers = {
    aws = aws.ap-southeast-3
  }
}
# module "spot_ap_southeast_4" {
#   source = "./modules/ec2"

#   iam_instance_profile = local.iam_instance_profile
#   user_data            = local.user_data
#   spot_price           = local.spot_price
#   instance_type        = local.instance_type
# #   volume_size_gb       = local.volume_size_gb
#   ssh_keypair_name     = local.key_name
#   ssh_public_key       = tls_private_key.private_key.public_key_openssh

#   providers = {
#     aws = aws.ap-southeast-4
#   }
# }

module "spot_ca_central_1" {
  source = "./modules/ec2"

  iam_instance_profile = local.iam_instance_profile
  user_data            = local.user_data
  spot_price           = local.spot_price
  instance_type        = local.instance_type
  volume_size_gb       = local.volume_size_gb
  ssh_keypair_name     = local.key_name
  ssh_public_key       = tls_private_key.private_key.public_key_openssh

  providers = {
    aws = aws.ca-central-1
  }
}

module "spot_eu_central_1" {
  source = "./modules/ec2"

  iam_instance_profile = local.iam_instance_profile
  user_data            = local.user_data
  spot_price           = local.spot_price
  instance_type        = local.instance_type
  volume_size_gb       = local.volume_size_gb
  ssh_keypair_name     = local.key_name
  ssh_public_key       = tls_private_key.private_key.public_key_openssh

  providers = {
    aws = aws.eu-central-1
  }
}

module "spot_eu_central_2" {
  source = "./modules/ec2"

  iam_instance_profile = local.iam_instance_profile
  user_data            = local.user_data
  spot_price           = local.spot_price
  instance_type        = local.instance_type
  volume_size_gb       = local.volume_size_gb
  ssh_keypair_name     = local.key_name
  ssh_public_key       = tls_private_key.private_key.public_key_openssh

  providers = {
    aws = aws.eu-central-2
  }
}

module "spot_eu_north_1" {
  source = "./modules/ec2"

  iam_instance_profile = local.iam_instance_profile
  user_data            = local.user_data
  spot_price           = local.spot_price
  instance_type        = local.instance_type
  volume_size_gb       = local.volume_size_gb
  ssh_keypair_name     = local.key_name
  ssh_public_key       = tls_private_key.private_key.public_key_openssh

  providers = {
    aws = aws.eu-north-1
  }
}

module "spot_eu_south_1" {
  source = "./modules/ec2"

  iam_instance_profile = local.iam_instance_profile
  user_data            = local.user_data
  spot_price           = local.spot_price
  instance_type        = local.instance_type
  volume_size_gb       = local.volume_size_gb
  ssh_keypair_name     = local.key_name
  ssh_public_key       = tls_private_key.private_key.public_key_openssh

  providers = {
    aws = aws.eu-south-1
  }
}

module "spot_eu_south_2" {
  source = "./modules/ec2"

  iam_instance_profile = local.iam_instance_profile
  user_data            = local.user_data
  spot_price           = local.spot_price
  instance_type        = local.instance_type
  volume_size_gb       = local.volume_size_gb
  ssh_keypair_name     = local.key_name
  ssh_public_key       = tls_private_key.private_key.public_key_openssh

  providers = {
    aws = aws.eu-south-2
  }
}

module "spot_eu_west_1" {
  source = "./modules/ec2"

  iam_instance_profile = local.iam_instance_profile
  user_data            = local.user_data
  spot_price           = local.spot_price
  instance_type        = local.instance_type
  volume_size_gb       = local.volume_size_gb
  ssh_keypair_name     = local.key_name
  ssh_public_key       = tls_private_key.private_key.public_key_openssh

  providers = {
    aws = aws.eu-west-1
  }
}

module "spot_eu_west_2" {
  source = "./modules/ec2"

  iam_instance_profile = local.iam_instance_profile
  user_data            = local.user_data
  spot_price           = local.spot_price
  instance_type        = local.instance_type
  volume_size_gb       = local.volume_size_gb
  ssh_keypair_name     = local.key_name
  ssh_public_key       = tls_private_key.private_key.public_key_openssh

  providers = {
    aws = aws.eu-west-2
  }
}

module "spot_eu_west_3" {
  source = "./modules/ec2"

  iam_instance_profile = local.iam_instance_profile
  user_data            = local.user_data
  spot_price           = local.spot_price
  instance_type        = local.instance_type
  volume_size_gb       = local.volume_size_gb
  ssh_keypair_name     = local.key_name
  ssh_public_key       = tls_private_key.private_key.public_key_openssh

  providers = {
    aws = aws.eu-west-3
  }
}

module "spot_me_central_1" {
  source = "./modules/ec2"

  iam_instance_profile = local.iam_instance_profile
  user_data            = local.user_data
  spot_price           = local.spot_price
  instance_type        = local.instance_type
  volume_size_gb       = local.volume_size_gb
  ssh_keypair_name     = local.key_name
  ssh_public_key       = tls_private_key.private_key.public_key_openssh

  providers = {
    aws = aws.me-central-1
  }
}

module "spot_me_south_1" {
  source = "./modules/ec2"

  iam_instance_profile = local.iam_instance_profile
  user_data            = local.user_data
  spot_price           = local.spot_price
  instance_type        = local.instance_type
  volume_size_gb       = local.volume_size_gb
  ssh_keypair_name     = local.key_name
  ssh_public_key       = tls_private_key.private_key.public_key_openssh

  providers = {
    aws = aws.me-south-1
  }
}

module "spot_sa_east_1" {
  source = "./modules/ec2"

  iam_instance_profile = local.iam_instance_profile
  user_data            = local.user_data
  spot_price           = local.spot_price
  instance_type        = local.instance_type
  volume_size_gb       = local.volume_size_gb
  ssh_keypair_name     = local.key_name
  ssh_public_key       = tls_private_key.private_key.public_key_openssh

  providers = {
    aws = aws.sa-east-1
  }
}

module "spot_us_east_2" {
  source = "./modules/ec2"

  iam_instance_profile = local.iam_instance_profile
  user_data            = local.user_data
  spot_price           = local.spot_price
  instance_type        = local.instance_type
  volume_size_gb       = local.volume_size_gb
  ssh_keypair_name     = local.key_name
  ssh_public_key       = tls_private_key.private_key.public_key_openssh

  providers = {
    aws = aws.us-east-2
  }
}

module "spot_us_west_1" {
  source = "./modules/ec2"

  iam_instance_profile = local.iam_instance_profile
  user_data            = local.user_data
  spot_price           = local.spot_price
  instance_type        = local.instance_type
  volume_size_gb       = local.volume_size_gb
  ssh_keypair_name     = local.key_name
  ssh_public_key       = tls_private_key.private_key.public_key_openssh

  providers = {
    aws = aws.us-west-1
  }
}

module "spot_us_west_2" {
  source = "./modules/ec2"

  iam_instance_profile = local.iam_instance_profile
  user_data            = local.user_data
  spot_price           = local.spot_price
  instance_type        = local.instance_type
  volume_size_gb       = local.volume_size_gb
  ssh_keypair_name     = local.key_name
  ssh_public_key       = tls_private_key.private_key.public_key_openssh

  providers = {
    aws = aws.us-west-2
  }
}


resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
