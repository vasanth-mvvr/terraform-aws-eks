terraform {
  required_providers {
        aws = {
        source = "hashicorp/aws"
        version = "5.98.0"
        }
  }
  backend "s3" {
    bucket = "reddym-remote-state"
    key= "expense-eks-eks-cluster"
    region = "us-east-1"
    dynamodb_table = "dynomodb-remote-state-lock"
  }
}

provider "aws" {
  region = "us-east-1"
}