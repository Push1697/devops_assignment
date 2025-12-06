#!/bin/bash
set -e

# Configuration
GITHUB_ORG="Push1697"
GITHUB_REPO="devops_assignment"
ROLE_NAME="github-actions-oidc-role"

echo "Setting up OIDC for $GITHUB_ORG/$GITHUB_REPO..."

# 1. Create OIDC Provider (if not exists)
if ! aws iam list-open-id-connect-providers | grep -q "token.actions.githubusercontent.com"; then
    echo "Creating OIDC Provider..."
    aws iam create-open-id-connect-provider \
        --url "https://token.actions.githubusercontent.com" \
        --client-id-list "sts.amazonaws.com" \
        --thumbprint-list "6938fd4d98bab03faadb97b34396831e3780aea1"
else
    echo "OIDC Provider already exists."
fi

PROVIDER_ARN=$(aws iam list-open-id-connect-providers --output text --query "OpenIDConnectProviderList[?contains(Arn, 'token.actions.githubusercontent.com')].Arn")

# 2. Create Trust Policy
cat > trust_policy.json <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "$PROVIDER_ARN"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringLike": {
                    "token.actions.githubusercontent.com:sub": "repo:$GITHUB_ORG/$GITHUB_REPO:*"
                }
            }
        }
    ]
}
EOF

# 3. Create Role
echo "Creating Role $ROLE_NAME..."
aws iam create-role --role-name $ROLE_NAME --assume-role-policy-document file://trust_policy.json || echo "Role might already exist, updating policy..."
aws iam update-assume-role-policy --role-name $ROLE_NAME --policy-document file://trust_policy.json

# 4. Attach Admin Policy (For assignment purposes)
aws iam attach-role-policy --role-name $ROLE_NAME --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

echo "----------------------------------------------------------------"
echo "Setup Complete!"
echo "Role ARN: arn:aws:iam::$(aws sts get-caller-identity --query Account --output text):role/$ROLE_NAME"
echo "----------------------------------------------------------------"
echo "Please add this Role ARN to your GitHub Secrets as 'ACTIONS_ROLE_ARN'"
rm trust_policy.json
