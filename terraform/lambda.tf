# -----------------------------------------------------------
# Lambda Function Resource Definition
# This block defines and deploys the AWS Lambda function
# that will process requests from API Gateway and call Comprehend.
# -----------------------------------------------------------
resource "aws_lambda_function" "analyze_text" {
  # Path to the zipped Lambda code
  # (This .zip should contain lambda_function.py and any dependencies)
  filename         = "../lambda/lambda_function_payload.zip"

  # The function's name in AWS (shown in the Lambda console)
  function_name    = "analyze_text"

  # The IAM role ARN that Lambda will assume when running
  # (Must have permissions to call Comprehend and write CloudWatch logs)
  role             = aws_iam_role.lambda_exec.arn

  # The entry point in your code: "filename.function_name"
  handler          = "lambda_function.lambda_handler"

  # The runtime (Python 3.11). Change if your code uses another version.
  runtime          = "python3.11"

  # Used to detect code changes for updates/deployments
  # (Base64-encoded SHA256 hash of your ZIP file)
  source_code_hash = filebase64sha256("../lambda/lambda_function_payload.zip")

  # Timeout in seconds (how long Lambda can run per invocation)
  timeout          = 10

}

# -----------------------------------------------------------
# SRE Notes:
# - Keep Lambda zipped code and .tf files in version control (but not .terraform or .zip in repo).
# - Always specify environment variables for flexibility.
# - Use source_code_hash to ensure Terraform updates Lambda if your code changes.
# - Set sensible timeout (avoid "hanging" Lambdas).
# -----------------------------------------------------------
