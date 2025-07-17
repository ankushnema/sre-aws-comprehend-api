# This block creates an IAM Role for the Lambda function
# Creates an IAM Role called comprehend_api_lambda_role.
# The assume_role_policy allows AWS Lambda service (lambda.amazonaws.com) 
# to "assume" (use) this role—this is what enables Lambda to get AWS credentials at runtime.
resource "aws_iam_role" "lambda_exec" {
  name = "comprehend_api_lambda_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# This block creates a custom IAM Policy for your Lambda
# What this does: 
# Creates a policy named lambda_comprehend_policy.
# Allows Lambda to:  Use Amazon Comprehend APIs (DetectSentiment, DetectEntities, DetectKeyPhrases).
# Write logs to CloudWatch (logs:* permissions).
# Resource: "*" means all resources—for production, use resource ARNs for tighter security.
resource "aws_iam_policy" "lambda_comprehend_policy" {
  name   = "lambda_comprehend_policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "comprehend:DetectSentiment",
          "comprehend:DetectEntities",
          "comprehend:DetectKeyPhrases",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

# This block attaches the above policy to the Lambda IAM role
# What this does: 
# Connects the custom policy (lambda_comprehend_policy) to the role Lambda will use.
# Result: Any Lambda using comprehend_api_lambda_role will have the necessary permissions.
resource "aws_iam_role_policy_attachment" "lambda_comprehend_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_comprehend_policy.arn
}

# How They’re Connected
# Lambda function uses aws_iam_role.lambda_exec.
# Policy gives that role permission to use Comprehend and CloudWatch logs.
# Attachment links policy to role.

# What is an ARN?
# An ARN uniquely identifies any AWS resource, like a Lambda function, IAM role, S3 bucket, DynamoDB table, etc.
# It’s a string with a standard format used in IAM policies, Terraform, AWS CLI, SDKs, etc.
# format: arn:partition:service:region:account-id:resource-type/resource-name
# S3 bucket: arn:aws:s3:::my-bucket-name
# Lambda function: arn:aws:lambda:us-east-1:123456789012:function:my-function
# IAM Role: arn:aws:iam::123456789012:role/comprehend_api_lambda_role
# SNS Topic: arn:aws:sns:us-east-1:123456789012:my-topic
# Why are ARNs important?
# IAM Policies: You can give access to a specific resource by referencing its ARN (e.g., "allow access to this bucket only").
# Terraform: Often outputs ARNs, and you use ARNs to reference resources.
# Cross-service references: AWS uses ARNs to allow one service (like Lambda) to access another (like S3 or Comprehend).


