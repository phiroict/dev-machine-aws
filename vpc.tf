terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.200.0.0/16"
  tags = {
    Name = "dev-vpc"
  }
}

resource "aws_subnet" "subnet" {
    vpc_id = aws_vpc.dev-vpc.id
    cidr_block = "10.200.1.0/24"
    tags = {
        Name = "dev-vpc-subnet"
    }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.dev-vpc.id

  tags = {
    Name = "main"
  }
}


resource "aws_default_route_table" "drt" {
  default_route_table_id = aws_vpc.dev-vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

