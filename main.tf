terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }


  backend "s3" {
    bucket = "descomplicando-terraform-course"
    key    = "terraform-test.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  alias = "east-1"
  region = "us-east-1"
}

provider "aws" {
  alias = "west-2"
  region = "us-west-2"
}