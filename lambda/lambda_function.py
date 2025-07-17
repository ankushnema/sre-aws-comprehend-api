import json      # For working with JSON strings and dicts
import boto3     # AWS SDK for Python (lets us call AWS services)
import os        # For reading environment variables (like AWS_REGION)

# Create a client to interact with Amazon Comprehend
comprehend = boto3.client('comprehend', region_name=os.environ.get('AWS_REGION', 'us-east-1'))

def lambda_handler(event, context):
    """
    Lambda entrypoint for API Gateway (proxy integration).
    Receives HTTP POST requests, expects JSON with a 'text' key.
    Responds with sentiment analysis result (from Amazon Comprehend).
    """
    try:
        # API Gateway sends body as a JSON string—parse to dict
        body = json.loads(event.get('body', '{}'))

        # Get the 'text' field from the body (could be missing or empty)
        text = body.get('text')

        # If 'text' is missing or empty, return a 400 error to the client
        if not text:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "No text provided"})
            }

        # Call Amazon Comprehend to analyze sentiment of the input text
        # ('en' = English; change as needed for other languages)
        result = comprehend.detect_sentiment(Text=text, LanguageCode='en')

        # Return the sentiment result and scores as a JSON response
        return {
            "statusCode": 200,
            "body": json.dumps({
                "Sentiment": result['Sentiment'],
                "SentimentScore": result['SentimentScore']
            })
        }
    except Exception as e:
        # SRE NOTE: Good practice is to log errors (print goes to CloudWatch Logs)
        # We'll add richer logging/alerting in later SRE steps!
        print(f"Error in Lambda: {str(e)}")   # This is logged to CloudWatch by default
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
