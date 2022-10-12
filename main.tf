# Terraform Configuration
terraform {
  required_version = "1.1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.14.0"
    }
  }
}

# tfstate管理用の設定
terraform {
  backend "s3" {
    bucket         = "ecs-sandbox-tfstate"
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
    dynamodb_table = "ecs-sandbox-tfstate-backend"
  }
}

# Provider
provider "aws" {
  region = "ap-northeast-1"
}

# Variables
variable "project" {
  type = string
}

variable "environment" {
  type = string
}
