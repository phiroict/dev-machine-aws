packer {
    required_plugins {
      amazon = {
        version = ">= 0.0.2"
        source  = "github.com/hashicorp/amazon"
      }
    }
  }
  
  source "amazon-ebs" "ubuntu" {
    ami_name      = "dev-machine-linux-aws"
    instance_type = "t2.micro"
    region        = "ap-southeast-2"
    associate_public_ip_address = true    
    ssh_private_key_file = "id_rsa"
    ssh_timeout = "15m"
    source_ami_filter {
      filters = {
        name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
        root-device-type    = "ebs"
        virtualization-type = "hvm"
      }
      most_recent = true
      owners      = ["679593333241"]
    }
    vpc_filter {
      filters = {
        "tag:Name" = "dev-vpc"
        isDefault = false
      }
    }
    subnet_filter {
      filters = {
        "tag:Name" = "dev-vpc-subnet"
      }
    }
    
    ssh_username = "ubuntu"
  }
  
  build {
    name    = "dev-machine"
    sources = [
      "source.amazon-ebs.ubuntu"
    ]
    
  
  }