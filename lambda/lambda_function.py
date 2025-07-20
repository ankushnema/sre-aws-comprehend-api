import json      # For working with JSON strings and dicts
import boto3     # AWS SDK for Python (lets us call AWS services)
import os        # For reading environment variables (like AWS_REGION)
import logging   # For structured logging (SRE best practice)

# Configure logger for Lambda; logs appear in CloudWatch
logger = logging.getLogger()
logger.setLevel(logging.INFO)  # Log level INFO covers most prod/debug needs

# Create a client to interact with Amazon Comprehend
comprehend = boto3.client('comprehend', region_name=os.environ['AWS_REGION'])

def lambda_handler(event, context):
    """
    Lambda entrypoint for API Gateway (proxy integration).
    Receives HTTP POST requests, expects JSON with a 'text' key.
    Responds with sentiment analysis result (from Amazon Comprehend).
    Logs all events, results, warnings, and errors for observability.
    """
    try:
        # Log the full incoming event for traceability/debugging
        logger.info(f"Received event: {json.dumps(event)}")

        # API Gateway sends body as a JSON string—parse to dict
        body = json.loads(event.get('body', '{}'))

        # Get the 'text' field from the body (could be missing or empty)
        text = body.get('text')

        # If 'text' is missing or empty, return a 400 error to the client and log warning
        if not text:
            logger.warning("No 'text' provided in request body.")
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "No text provided"})
            }

        # Call Amazon Comprehend to analyze sentiment of the input text
        # ('en' = English; change as needed for other languages)
        result = comprehend.detect_sentiment(Text=text, LanguageCode='en')

        # Log the result from Comprehend for monitoring/audit purposes
        logger.info(f"Comprehend result: {json.dumps(result)}")

        # Return the sentiment result and scores as a JSON response
        return {
            "statusCode": 200,
            "body": json.dumps({
                "Sentiment": result['Sentiment'],
                "SentimentScore": result['SentimentScore']
            })
        }
    except Exception as e:
        # Log errors with stack trace for SRE and alerting
        logger.error(f"Exception occurred: {str(e)}", exc_info=True)
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
