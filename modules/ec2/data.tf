data "aws_ami" "alpine" {
  most_recent      = true
  owners           = ["538276064493"]

  filter {
    name   = "name"
    values = ["alpine-*-x86_64-uefi-cloudinit-r0"]
  }
}