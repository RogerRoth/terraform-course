terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }


  backend "s3" {
    bucket = "descomplicando-terraform-course"
    dynamodb_table = "terraform-state-lock"
    key    = "terraform-test.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  alias  = "east-1"
  region = "us-east-1"
}