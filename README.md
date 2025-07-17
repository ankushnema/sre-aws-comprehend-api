# sre-aws-comprehend-api

A production-grade, SRE-focused, fully serverless REST API for AI-powered text analysis (AWS Comprehend, API Gateway, Lambda).

---

## 🌟 Features
- Free-tier, cost-optimized, scalable, and interview-ready
- Input: POST text to REST API endpoint
- Analysis: Lambda triggers Amazon Comprehend (sentiment, entities, key phrases)
- SRE Best Practices: SLOs, alerting, logging, monitoring, security, DLQ, runbook, and more

---

## 🚦 Quickstart
- See `SETUP_GUIDE.md` for step-by-step setup and deployment.
- See `RUN_GUIDE.md` for step-by-step run the project.
---

## Details about iam.tf

### IAM Relationship Diagram

```plaintext
+---------------------------+
|     Lambda Function       |
+-----------+---------------+
            |
     assumes role
            v
+---------------------------+
|   IAM Role: lambda_exec   |
+-----------+---------------+
            |
 attached policy
            v
+-------------------------------+
| IAM Policy: lambda_comprehend |
|  - comprehend:Detect*         |
|  - logs:CreateLogGroup        |
|  - logs:PutLogEvents          |
+-------------------------------+

```

## Details about api_gateway.tf

## 📊 API Gateway to Lambda Architecture

```plaintext
+-------------------------------+
|     Client (curl/Postman)     |
+---------------+---------------+
                |
        POST /analyze (JSON)
                |
+---------------v---------------+
|      API Gateway (REST)       |
| - /analyze Resource           |
| - POST Method                 |
| - Lambda Integration (Proxy)  |
+---------------+---------------+
                |
    Invokes Lambda Function
                |
+---------------v---------------+
|       Lambda Function         |
|   (analyze_text in Python)    |
+---------------+---------------+
                |
    Uses AWS SDK (boto3) to call
                |
+---------------v---------------+
|     Amazon Comprehend (AI)    |
+-------------------------------+

```

### 🚦 api_gateway Request Flow

1. **Client** sends a `POST` request with JSON to the `/analyze` endpoint on API Gateway.
2. **API Gateway** (using AWS_PROXY integration) forwards the request to the **Lambda function**.
3. **Lambda function** runs your Python code to process the request.
4. **Lambda** uses the AWS SDK (`boto3`) to call **Amazon Comprehend** for sentiment or key phrase analysis.
5. **Lambda** returns the analysis result back to **API Gateway**, which then replies to the client.


## Lambda Function Overview

- **Language:** Python 3.11
- **Purpose:** Handles POST requests to `/analyze` endpoint, analyzes text using Amazon Comprehend, returns sentiment.
- **Key Points:**
  - Uses `boto3` (AWS SDK for Python) to call Comprehend.
  - Reads region from environment variable (`AWS_REGION`), making it portable.
  - Handles errors and returns user-friendly messages.
  - Logs errors to CloudWatch by default (`print` statements).

---

### 🟢 Lambda Function Internal Flow

```plaintext
+-----------------------------+
|  Lambda Handler Invoked     |
|  (lambda_handler)           |
+-----------------------------+
             |
    Receives API Gateway event
             |
+------------v-------------+
| Parse event['body'] JSON |
+------------+-------------+
             |
   Extract "text" from body
             |
+------------v-------------+
|  Validate: text present? |
+------------+-------------+
   |                     |
  Yes                   No
   |                     |
   v                     v
Analyze text         Return 400
with Comprehend      error: "No text"
   |
   v
+------------------------------+
| Call boto3.comprehend        |
| .detect_sentiment()          |
+------------------------------+
   |
   v
+------------------------------+
| Return 200 w/ sentiment      |
| & SentimentScore as JSON     |
+------------------------------+
             |
           (if any exception)
             |
   +---------v----------+
   | Return 500 error   |
   +--------------------+


```
#### 📝 Lambda Workflow Summary

- The Lambda function is triggered by API Gateway and receives the request event.
- It parses the incoming JSON, checks for a `"text"` key, and validates input.
- If the input is valid, it calls Amazon Comprehend using `boto3` to perform sentiment analysis.
- The function returns the sentiment result (and score) as a JSON response.
- If `"text"` is missing or an error occurs, the function returns a relevant error message with the correct HTTP status code.





## 📚 SRE/DevOps Best Practices (tracked throughout project)
- SLOs and Error Budgets
- CloudWatch alarms, dashboards, and logs
- SNS/email alerting
- Runbook, monitoring, troubleshooting steps
- IAM: least privilege, secure defaults
- Cost optimization and clean-up
- Automated validation & documentation

---
