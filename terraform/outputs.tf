# outputs.tf

# Output the API Gateway invoke URL
output "api_url" {
  value = "https://${aws_api_gateway_rest_api.comprehend_api.id}.execute-api.us-east-1.amazonaws.com/prod/analyze"
  description = "The POST endpoint for text analysis"
}

# Output the Lambda Function Name
output "lambda_function_name" {
  value       = aws_lambda_function.analyze_text.function_name
  description = "Name of the deployed Lambda function"
}
