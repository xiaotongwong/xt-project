terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-1"
}

resource "aws_vpc" "gitea_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "gitea_subnet" {
  vpc_id            = aws_vpc.gitea_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}