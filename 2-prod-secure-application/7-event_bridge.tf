
# EVENT BRIDGE

## EventBridge Rule to Detect SSM PutParameter and UpdateParameter
resource "aws_cloudwatch_event_rule" "ssm_param_change" {
  name        = "ssm-param-change-rule"
  description = "Triggers Lambda when SSM parameter is created or updated"
  event_pattern = jsonencode({
    source = ["aws.ssm"],
    "detail-type" = ["AWS API Call via CloudTrail"],
    detail = {
      eventSource = ["ssm.amazonaws.com"],
      eventName   = ["PutParameter", "UpdateParameter"]
    }
  })
}


## Attach EventBridge Target (Lambda)
resource "aws_cloudwatch_event_target" "lambda_on_param_change" {
  rule      = aws_cloudwatch_event_rule.ssm_param_change.name
  target_id = "trigger-lambda-on-ssm-change"
  arn       = aws_lambda_function.update_ip_set.arn
  depends_on = [ aws_lambda_function.update_ip_set ]
}

## Allow EventBridge to Invoke Lambda
resource "aws_lambda_permission" "allow_eventbridge_for_ssm_change" {
  statement_id  = "AllowExecutionFromSSMChangeEvent"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.update_ip_set.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ssm_param_change.arn
  depends_on = [ aws_cloudwatch_event_target.lambda_on_param_change ]
}
