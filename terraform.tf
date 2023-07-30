terraform {
  required_version = "1.3.6"

  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.48.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.17.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.8.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
}

data "aws_caller_identity" "current" {} # used for accesing Account ID and ARN

provider "aws" {
  default_tags {
    tags = {
      Project      = var.tag_project
      Environment  = var.tag_environment
      SystemOwner  = var.tag_owner_system
      BillingRoute = var.tag_billing_route
    }
  }
  region     = "ap-southeast-1"
}