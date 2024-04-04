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
  access_key = "AKIAXYKJRWNRHCBXGFRF"
  secret_key = "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"
}
