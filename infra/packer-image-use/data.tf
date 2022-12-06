data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["dev-machine-linux-aws-20221206-091613"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["774492638540"] # Private
}

data  aws_vpc "vpc" {
  filter {
    name   = "tag:Name"
    values = ["dev-vpc"]
  }
}

data aws_subnet "subnet"{
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["dev-vpc-subnet"]
  }
}