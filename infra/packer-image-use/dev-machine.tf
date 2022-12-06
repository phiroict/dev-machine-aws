resource "aws_instance" "dev-machine" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name = "image_key"
  associate_public_ip_address = true
  subnet_id = data.aws_subnet.subnet.id
  tags = {
    Name  = "Dev-machine-phiro"
    Owner = "Philip Rodrigues"
    ExpiredAt = "20250101"
  }
}