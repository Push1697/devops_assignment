#!/bin/bash
set -e

# Unique bucket name (must be globally unique)
BUCKET_NAME="devops-assignment-state-$(aws sts get-caller-identity --query Account --output text)"
REGION="us-east-1"

echo "Creating S3 Bucket for Terraform State: $BUCKET_NAME"

if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
    echo "Bucket already exists."
else
    aws s3api create-bucket --bucket "$BUCKET_NAME" --region "$REGION"
fi

# Enable Versioning (Best Practice)
aws s3api put-bucket-versioning --bucket "$BUCKET_NAME" --versioning-configuration Status=Enabled

echo "----------------------------------------------------------------"
echo "Backend Setup Complete!"
echo "Bucket Name: $BUCKET_NAME"
echo "Region: $REGION"
echo "----------------------------------------------------------------"
echo "Please update 'terraform/backend.tf' with this bucket name."
