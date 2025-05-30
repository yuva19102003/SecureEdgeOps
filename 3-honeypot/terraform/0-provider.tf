


# terraform {
#   backend "s3" {
#     bucket = "yuva19102003-tf-remote-backend-s3-bucket"
#     key    = "honeypot-setup/terraform.tfstate"
#     region = "us-east-1"
#   }
# }

provider "aws" {
  region  = "us-east-1"  # Specify the AWS region for your resources
  profile = "default"    # Specify the AWS CLI profile (optional)
  #profile = "iamuser"
}
