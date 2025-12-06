#!/bin/bash
set -e

echo "Destroying Infrastructure..."
cd terraform
terraform destroy -auto-approve
cd ..
echo "Teardown Complete!"
