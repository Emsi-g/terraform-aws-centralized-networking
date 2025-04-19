terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

provider "aws" {
  alias = "account-b"
  region = "ap-southeast-1"
  profile = "assume-role-tf"
}