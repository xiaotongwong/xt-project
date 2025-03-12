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
  for_each = {
    subnet_1 = { cidr = "10.0.1.0/24", az = "us-west-1a" }
    subnet_2 = { cidr = "10.0.2.0/24", az = "us-west-1c" }
  }

  vpc_id            = aws_vpc.gitea_vpc.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
}

resource "aws_internet_gateway" "gitea_igw" {
  vpc_id = aws_vpc.gitea_vpc.id

  tags = {
    Name = "gitea_igw"
  }
}

resource "aws_route_table" "gitea_route_table" {
  vpc_id = aws_vpc.gitea_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gitea_igw.id
  }

  tags = {
    Name = "gitea_route_table"
  }
}

resource "aws_route_table_association" "gitea_association" {
  for_each = aws_subnet.gitea_subnet

  subnet_id      = each.value.id
  route_table_id = aws_route_table.gitea_route_table.id
}