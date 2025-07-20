# Alarm: Lambda function errors
resource "aws_cloudwatch_metric_alarm" "lambda_error_alarm" {
  alarm_name          = "LambdaErrorAlarm-analyze_text"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 300  # 5 minutes
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Alarm if the Lambda function returns any errors in a 5-minute window"
  dimensions = {
    FunctionName = aws_lambda_function.analyze_text.function_name
  }
}

# Alarm: Lambda function running slow
resource "aws_cloudwatch_metric_alarm" "lambda_duration_alarm" {
  alarm_name          = "LambdaDurationAlarm-analyze_text"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = 300  # 5 minutes
  statistic           = "Average"
  threshold           = 4000 # 4 seconds (adjust as needed)
  alarm_description   = "Alarm if average Lambda duration is >= 4 seconds in a 5-minute window"
  dimensions = {
    FunctionName = aws_lambda_function.analyze_text.function_name
  }
}
