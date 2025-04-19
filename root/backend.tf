terraform {
  backend "s3" {
    bucket = "terraform-state-marc"
    key = "aws-centralized-networking.tfstate"
    region = "ap-southeast-1"
    encrypt = true
    use_lockfile = true
  }
}