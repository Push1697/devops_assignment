# Infrastructure Deployment Project

This repo contains the work for the DevOps practical assignment. I've built a complete pipeline to deploy a Node.js REST API on AWS using Terraform.

## What's in here?

I decided to use **Terraform** for this because it's effectively the industry standard and allows for much cleaner state management than CloudFormation.

The project is broken down like this:

*   **`terraform/`**: All the infrastructure code. I set up a custom VPC, an Application Load Balancer (ALB), and an Auto Scaling Group (ASG).
*   **`app/`**: A simple Node.js application I wrote to test the deployment. It just responds with the hostname so we can see load balancing in action.
*   **`scripts/`**: Some helper scripts I wrote to make deploying easier (so you don't have to remember the full terraform commands).
*   **`.github/`**: The CI/CD pipeline. I set up OpenID Connect (OIDC) so GitHub can talk to AWS securely without us having to pass hardcoded keys around.

## Architecture Highlights

I focused heavily on security and "correctness" for this setup:
1.  **Isolation**: The actual servers run in **Private Subnets**. They have no public IP addresses. No one can hit them directly from the internet.
2.  **Traffic Flow**: The only way in is through the Load Balancer, which lives in the Public Subnets.
3.  **Zero-Touch Config**: The server boots up, installs software, and starts the app automatically using what's called "User Data".

## How to Deploy / Test

You have two ways to run this.

### Method 1: The "I want to see it now" way (Local)
If you have your AWS Access Keys on your machine (like via `aws configure`), you can just run the script:

```bash
./scripts/deploy.sh
```

It'll take about 2-3 minutes. When it's done, it gives you a URL.
If you `curl` that URL, you'll see the response from the internal server.

### Method 2: The "DevOps" way (GitHub Actions)

**Prerequisite: One-Time OIDC Setup**
Since we don't want the authentication role to be deleted when we destroy the infra, we set it up separately.

1.  Run the setup script (requires AWS CLI configured):
    ```bash
    ./scripts/setup_oidc.sh
    ```
2.  Copy the **Role ARN** output.
3.  Go to GitHub Repo -> Settings -> Secrets -> Actions.
4.  Add a secret named `ACTIONS_ROLE_ARN` with that value.

Now, every time you push to `main`, GitHub will assume that role and deploy.
