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




## 📚 SRE/DevOps Best Practices (tracked throughout project)
- SLOs and Error Budgets
- CloudWatch alarms, dashboards, and logs
- SNS/email alerting
- Runbook, monitoring, troubleshooting steps
- IAM: least privilege, secure defaults
- Cost optimization and clean-up
- Automated validation & documentation

---
