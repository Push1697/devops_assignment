terraform {
  backend "s3" {
    bucket = "devops-assignment-state-450070307294"
    key    = "devops-assignment/terraform.tfstate"
    region = "us-east-1"
  }
}
