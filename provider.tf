# configure aws provider
provider "aws" {
  region  = var.region
#  profile = "assignment"
}

# configure backend
terraform {
   required_providers {
   aws={
        source = "hashicorp/aws"
        version = "~>6.16"
    }
   }
  #  backend "s3" {
  #   bucket         = "assignment-aws-eks-cluster-2025-10-20"
  #   key            = "aws/us-east-1/assignment-aws-eks-cluster.tfstate"
  #   region         = "us-east-1"
  # #  profile        = "assignment"
  #   use_lockfile   = true
  #   encrypt        = true
  # }
}