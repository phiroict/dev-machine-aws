packer {
    required_plugins {
      amazon = {
        version = ">= 0.0.2"
        source  = "github.com/hashicorp/amazon"
      }
    }
  }
  
  source "amazon-ebs" "ubuntu" {
    ami_name      = "dev-machine-linux-aws-${formatdate("YYYYMMDD-HHmmss",timestamp())}"
    instance_type = "t2.micro"
    region        = "ap-southeast-2"

    associate_public_ip_address = true
    temporary_key_pair_type = "ed25519"
    ssh_timeout = "10m"
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

    provisioner "shell" {
      inline = [
        "sudo apt update",
        "sudo apt upgrade -y",
        "sudo apt install git ca-certificates curl gnupg lsb-release  -y",
        "sudo mkdir -p /etc/apt/keyrings",
        "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",
        "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
        "sudo apt update",
        "sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y",
        "sudo docker run hello-world",
        "sudo usermod -aG docker ubuntu"
      ]
    }
    
  
  }