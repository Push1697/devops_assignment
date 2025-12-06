#!/bin/bash
set -e

echo "Deploying Infrastructure..."
cd terraform
terraform init
terraform apply -auto-approve
cd ..
echo "Deployment Complete!"
