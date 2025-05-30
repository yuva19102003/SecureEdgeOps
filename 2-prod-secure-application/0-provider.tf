


# terraform {
#   backend "s3" {
#     bucket = "yuva19102003-tf-remote-backend-s3-bucket"
#     key    = "prod-secure-application/terraform.tfstate"
#     region = "us-east-1"
#   }
# }

provider "aws" {
  region  = "us-east-1"  # Specify the AWS region for your resources
  profile = "default"    # Specify the AWS CLI profile (optional)
  #profile = "iamuser"
}

data "aws_caller_identity" "current" {}
