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
  access_key = "AKIAXYKJRWNRPATRNWFJ"
  secret_key = "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"
}
