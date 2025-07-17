# Step 5: Deploy Lambda, API Gateway, and IAM with Terraform

This section describes how to deploy your AWS infrastructure—including Lambda, API Gateway, and IAM roles—using Terraform.

---

## Prerequisites

- All Terraform files (`provider.tf`, `iam.tf`, `lambda.tf`, `api_gateway.tf`, `outputs.tf`) are in your `terraform/` directory.
- Your Lambda code is zipped as `lambda_function_payload.zip` in the `lambda/` folder.
- AWS CLI is configured (`aws configure`) with permissions to create Lambda/API Gateway/IAM resources.

---

## Terraform Deployment Commands Explained

### 1. `terraform init`

- **What it does:**  
  Initializes your Terraform project directory. Downloads the required provider plugins (like AWS) and sets up local state management.

- **Why use it:**  
  Prepares your environment so other Terraform commands can work. Run this at least once per project, or any time you add a new provider/module.

- **Analogy:**  
  Like running `npm install` (Node) or `pip install` (Python) before starting development.

---

### 2. `terraform plan`

- **What it does:**  
  Shows you exactly what Terraform *would* do if you applied your configuration right now. It compares your desired infrastructure (code) with what's actually in AWS, and lists actions it will take (create, update, delete).

- **Why use it:**  
  Lets you review and verify planned changes before making them. Helps catch typos or mistakes before affecting real infrastructure.

- **Analogy:**  
  Like seeing a preview of changes before you commit code.

---

### 3. `terraform apply`

- **What it does:**  
  Executes the planned actions—actually creating, updating, or deleting resources in AWS as defined in your code. Prompts you to confirm before making changes.

- **Why use it:**  
  Deploys your infrastructure based on your configuration files.

- **Analogy:**  
  Like deploying your app after testing locally.

---

| Command            | What It Does                                    | Why Use It?                             |
|--------------------|-------------------------------------------------|-----------------------------------------|
| `terraform init`   | Prepares directory, downloads providers         | Sets up project environment             |
| `terraform plan`   | Shows planned changes before execution          | Lets you review and catch mistakes      |
| `terraform apply`  | Makes real changes in AWS (creates/updates infra)| Deploys your infrastructure             |


---

## Deployment Steps

1. **Open Terminal and navigate to your Terraform directory:**

    ```bash
    cd ~/Downloads/sre-aws-comprehend-api/terraform
    ```

2. **Initialize Terraform (download providers and set up state):**

    ```bash
    terraform init
    ```

3. **Preview the changes that will be made (always recommended):**

    ```bash
    terraform plan
    ```

4. **Apply the Terraform configuration to deploy resources:**

    ```bash
    terraform apply
    ```

    - Review the plan and type `yes` when prompted.
    - Wait for Terraform to finish the deployment.
    - Look for a message like: `Apply complete!`

5. **Retrieve your API Gateway endpoint URL:**

    - If you defined an output for your API URL in `outputs.tf`, it will be displayed after a successful apply.
    - Example:
      ```
      api_url = https://<api-id>.execute-api.<region>.amazonaws.com/prod/analyze
      ```

---

## Troubleshooting

- **If you see errors during `terraform init`, make sure you have an internet connection and your AWS credentials are set up.**
- **If you see errors during `terraform plan` or `apply`:**
    - Double-check file paths for your Lambda zip file.
    - Ensure your IAM permissions allow creation of Lambda, IAM, and API Gateway resources.
    - Paste any error here for instant help!

---

## Next Steps

- Once deployment is complete, proceed to **test your API endpoint** as described in the next section.
- After confirming your API is working, you’ll add SRE features like CloudWatch monitoring, alarms, and alerting.

---

