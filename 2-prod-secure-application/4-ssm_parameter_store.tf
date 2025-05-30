
# SSM PARAMETER STORE

resource "aws_ssm_parameter" "blocked_ips" {
  name        = "/waf/blocked_ips"         # Name of the parameter (can be customized)
  description = "List of blocked IPs for WAF"
  type        = "StringList"               # StringList type to store multiple IPs
  value       = "[]"                         # Initially empty
  overwrite   = true                       # Set to true if you want to overwrite the parameter value
  depends_on = [ aws_wafv2_ip_set.blocked_ips ]
}
