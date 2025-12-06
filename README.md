# Infrastructure Deployment Project

Welcome to my DevOps practical assignment submission. I've built a robust, production-grade infrastructure pipeline to deploy a specific Node.js REST API on AWS using Terraform.

## Why Terraform?
I chose **Terraform** over CloudFormation because it's the industry standard for cloud-agnostic Infrastructure as Code. It offers cleaner state management and modularity, which I believe is critical for maintaining long-term projects.

## Codebase Organization
Here is how I structured the project:

*   **`terraform/`**: The core infrastructure logic. I implemented a custom VPC, an Application Load Balancer (ALB), and an Auto Scaling Group (ASG) from scratch.
*   **`app/`**: A lightweight Node.js application I wrote to verify the deployment. It echoes the hostname so we can validate that load balancing is actually working.
*   **`scripts/`**: Helper scripts I created to simplify common tasks like deploying, destroying, and setting up the backend.
*   **`.github/`**: The CI/CD pipelines. I configured OpenID Connect (OIDC) to allow GitHub to deploy securely to AWS without storing long-lived access keys.

## Architecture Highlights
I focused heavily on security best practices:
1.  **True Isolation**: The application servers run in **Private Subnets** with no public IP addresses. They are completely unreachable from the internet directly.
2.  **Controlled Access**: The only entry point is the Load Balancer, placed in the Public Subnets.
3.  **Zero-Touch Provisioning**: The instances boot up, install dependencies, and start the app automatically using Terraform's `user_data`.

---

## ⚙️ Project Configuration
If you are setting this up in a **new AWS account** (or for the interview demo), please follow these one-time configuration steps.

### 1. Configure AWS Credentials (Local)
Ensure you have an IAM User with Administrator Access configured locally.
```bash
aws configure
# Enter Access Key ID, Secret Access Key, and Region (us-east-1)
```

### 2. Setup GitHub OIDC (One-Time)
This establishes trust between GitHub and AWS so the CI/CD pipeline works securely.
1.  Open `scripts/setup_oidc.sh` and check the `GITHUB_ORG`/`GITHUB_REPO` variables.
2.  Run the script:
    ```bash
    ./scripts/setup_oidc.sh
    ```
3.  Copy the **Role ARN** output and add it as a Repository Secret named `ACTIONS_ROLE_ARN` in GitHub.

### 3. Setup Remote Backend (One-Time)
This creates an S3 bucket to store the Terraform state file, allowing GitHub Actions to track resources.
1.  Run the backend setup script:
    ```bash
    ./scripts/setup_backend.sh
    ```
2.  Copy the generated Bucket Name (e.g., `devops-assignment-state-123...`).
3.  Open `terraform/backend.tf` and update the `bucket` field.
4.  Commit and push this change to GitHub.

---

## 🚀 How to Deploy

### Option 1: The "DevOps" Way (GitHub Actions)
This is the preferred method as it simulates a real production environment.
1.  Push a commit to the `main` branch.
2.  Go to the **Actions** tab in GitHub.
3.  Watch the **Infrastructure Pipeline** run. It will plan and apply the changes automatically.

### Option 2: The "Manual" Way (Local)
If you want to test rapidly from your machine:
```bash
./scripts/deploy.sh
```
This script wraps the terraform commands for convenience.

## 💥 Teardown (Important!)
To ensure you aren't charged for running instances, you can destroy everything easily.

**Via GitHub Actions:**
1.  Go to **Actions** -> **Infrastructure Pipeline** -> **Run workflow**.
2.  Select **destroy** from the dropdown menu and run it.

**Via Local Terminal:**
```bash
./scripts/destroy.sh
```

---
*Thank you for reviewing my assignment!*
