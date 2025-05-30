
# LAMBDA

## IAM Role for Lambda
resource "aws_iam_role" "lambda_execution_role" {
  name               = "lambda_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      }
    ]
  })
}

## IAM Policy for Lambda to Access SSM and WAF
resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_ssm_waf_policy"
  description = "Policy for Lambda to access SSM Parameter Store and WAF"

  policy = jsonencode({
  Version = "2012-10-17"
  Statement = [
    {
      Action   = ["ssm:GetParameter", "ssm:PutParameter"]
      Effect   = "Allow"
      Resource = "arn:aws:ssm:us-east-1:${data.aws_caller_identity.current.account_id}:parameter/waf/blocked_ips"
    },
    {
      Action   = [
        "wafv2:ListIPSets",
        "wafv2:GetIPSet",
        "wafv2:UpdateIPSet"
      ]
      Effect   = "Allow"
      Resource = "arn:aws:wafv2:us-east-1:${data.aws_caller_identity.current.account_id}:global/ipset/*/*"
    }
  ]
})

}

## Attach custom policy to Lambda role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

## Attach AWS managed policy to allow CloudWatch Logs access
resource "aws_iam_role_policy_attachment" "lambda_logging_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}



## Package the Lambda code into a zip file
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/code/lambda/waf_ip_sets.py"
  output_path = "${path.module}/code/lambda/waf_ip_sets.zip"
}

## Lambda Function
resource "aws_lambda_function" "update_ip_set" {
  function_name = "update_ip_set"
  filename      = data.archive_file.lambda_zip.output_path
  handler = "waf_ip_sets.lambda_handler"
  runtime = "python3.12"
  role = aws_iam_role.lambda_execution_role.arn
  environment {
    variables = {
      IPSET_NAME = "blocked-ips"
      SSM_PARAM  = "/waf/blocked_ips"
    }
  }
}


## Lambda Permissions (to Allow EventBridge or other services to Trigger Lambda)
resource "aws_lambda_permission" "allow_eventbridge_to_invoke_lambda" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.update_ip_set.function_name
  principal     = "events.amazonaws.com"
  statement_id  = "AllowEventBridgeToInvokeLambda"
}
