terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIAXYKJRWNRBVF26DLF"
  secret_key = "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"
}
