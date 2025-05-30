output "bucket_name" {
  value = aws_s3_bucket.Site_Origin.bucket
}

output "cloudfront-domain-name" {
  value = aws_cloudfront_distribution.Site_Access.domain_name
}

output "ssm_parameter_name" {
  description = "The name of the blocked IPs SSM parameter"
  value       = aws_ssm_parameter.blocked_ips.name
}

output "waf_ip_set_id" {
  description = "The ID of the WAF IP Set"
  value       = aws_wafv2_ip_set.blocked_ips.id
}

output "waf_web_acl_arn" {
  description = "The ARN of the WAF Web ACL"
  value       = aws_wafv2_web_acl.cloudfront_waf.arn
}


output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.update_ip_set.arn
}

output "cloudwatch_event_rule_arn" {
  description = "ARN of the CloudWatch Event rule"
  value       = aws_cloudwatch_event_rule.ssm_param_change.arn
}

output "cloudtrail_s3_bucket" {
  description = "S3 bucket for CloudTrail logs"
  value       = aws_s3_bucket.cloudtrail_logs.bucket
}

output "cloudwatch_event_target_id" {
  description = "ID of the CloudWatch Event Target"
  value       = aws_cloudwatch_event_target.lambda_on_param_change.target_id
}

