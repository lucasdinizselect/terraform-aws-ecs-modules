resource "aws_cloudwatch_log_group" "main" {
  name = format("%s/service/logs", var.service_name)
}