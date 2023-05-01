# This bucket needs to already exist beforehand.
terraform {
  backend "s3" {
    bucket     = "ibr-terraform-state"
    key        = "tfstate"
    region     = "us-east-1"
  }
}
