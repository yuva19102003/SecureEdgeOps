
# S3 BUCKET


## Create bucket
resource "aws_s3_bucket" "Site_Origin" {
  bucket = "yuva19102003-aws-honeypot-project-secure-application" 
}


## Upload file in S3 bucket
resource "aws_s3_object" "index_file" {
  bucket = aws_s3_bucket.Site_Origin.bucket
  key    = "index.html"
  source = "code/s3_files/index.html"
  content_type = "text/html"
  depends_on = [ aws_s3_bucket.Site_Origin ]
}


## permission for public access
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.Site_Origin.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


## Assign policy to allow CloudFront to reach S3 bucket
resource "aws_s3_bucket_policy" "origin" {
  depends_on = [
    aws_cloudfront_distribution.Site_Access
  ]
  bucket = aws_s3_bucket.Site_Origin.id
  policy = data.aws_iam_policy_document.origin.json
  
}

## Create policy to allow CloudFront to reach S3 bucket
data "aws_iam_policy_document" "origin" {
  depends_on = [
    aws_cloudfront_distribution.Site_Access,
    aws_s3_bucket.Site_Origin
  ]
  statement {
    sid    = "3"
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    principals {
      identifiers = ["cloudfront.amazonaws.com"]
      type        = "Service"
    }
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.Site_Origin.bucket}/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [
        aws_cloudfront_distribution.Site_Access.arn
      ]
    }
  }
}


#-----------------------------------------------------------------------------------------------------------------------------------------------------------
