# ------------------------------
# Create the REST API
# What: Sets up the main API Gateway REST API.
# Why: Container for all endpoints, configs, and stages.
# SRE: Naming, documentation, discoverability, and central management.
resource "aws_api_gateway_rest_api" "comprehend_api" {
  name        = "ComprehendTextAPI"
  description = "REST API for text sentiment analysis using Lambda and Comprehend"
}

# ------------------------------
# /analyze Resource (Path)
# What: Adds a resource (path) /analyze to the API.
# Why: Defines the endpoint for users to POST text for analysis.
# SRE: Clear, self-documenting endpoint structure.
resource "aws_api_gateway_resource" "analyze" {
  rest_api_id = aws_api_gateway_rest_api.comprehend_api.id
  parent_id   = aws_api_gateway_rest_api.comprehend_api.root_resource_id
  path_part   = "analyze"
}

# ------------------------------
# POST Method on /analyze
# What: Allows POST requests on /analyze.
# Why: Accepts JSON text for analysis from clients.
# SRE: Open (no auth) for demo. Add IAM/Cognito for prod security.
resource "aws_api_gateway_method" "post_analyze" {
  rest_api_id   = aws_api_gateway_rest_api.comprehend_api.id
  resource_id   = aws_api_gateway_resource.analyze.id
  http_method   = "POST"
  authorization = "NONE"
}

# ------------------------------
# Integrate API Gateway with Lambda (AWS_PROXY)
# What: Connects API Gateway POST /analyze to Lambda using AWS_PROXY integration.
# Why: Forwards HTTP requests directly to Lambda with full event data.
# SRE: Proxy integration is decoupled, easier to maintain, and scales well.
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.comprehend_api.id
  resource_id             = aws_api_gateway_resource.analyze.id
  http_method             = aws_api_gateway_method.post_analyze.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.analyze_text.invoke_arn
}



# ------------------------------
# API Deployment & Stage
# What: Deploys API and exposes it at a live URL (prod stage).
# Why: Required to make API accessible to users.
# SRE: Enables environment separation (staging, prod).
resource "aws_api_gateway_deployment" "api_deployment" {
  # Wait for Lambda integration to be ready before deploying
  depends_on  = [aws_api_gateway_integration.lambda_integration]
  # Link to your API Gateway REST API resource
  rest_api_id = aws_api_gateway_rest_api.comprehend_api.id
}

resource "aws_api_gateway_stage" "prod" {
  d# Associate this stage with the most recent deployment above
  deployment_id = aws_api_gateway_deployment.api_deployment.id

  # Reference to the same REST API as above
  rest_api_id   = aws_api_gateway_rest_api.comprehend_api.id

  # Name of the stage shown in your API Gateway endpoint URL (/prod)
  stage_name    = "prod"

  # SRE NOTE: Stages are like environments ("dev", "test", "prod")—
  # lets you manage, promote, or configure features separately per stage.
}



# ------------------------------
# Lambda Permission for API Gateway
# What: Allows API Gateway to invoke Lambda.
# Why: Required for integration to work (else access denied).
# SRE: Explicit, least-privilege permission (only this API can invoke this Lambda).
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.analyze_text.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.comprehend_api.execution_arn}/*/*"
}
