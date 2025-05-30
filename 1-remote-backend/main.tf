
provider "aws" {
  region  = "us-east-1"  # Specify the AWS region for your resources
  profile = "default"    # Specify the AWS CLI profile (optional)
  #profile = "iamuser"
}


resource "aws_s3_bucket" "tfstate_bucket" {
  bucket = "yuva19102003-tf-remote-backend-s3-bucket"

  tags = {
    Name        = "Terraform state files"
    Environment = "Prod"
  }
}


output "s3_bucket_name" {
  value       = aws_s3_bucket.tfstate_bucket.bucket
  description = "The name of the S3 bucket storing the Terraform state"
}

output "s3_bucket_region" {
  value       = aws_s3_bucket.tfstate_bucket.region
  description = "The AWS region where the S3 bucket is located"
}
