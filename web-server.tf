# Create Security group for Web Server in private subnet

resource "aws_security_group" "sg_ws" {
  name        = "sg-ws"
  description = "Allow web server network traffic"
  vpc_id      = aws_vpc.ongc_vpc.id

  ingress {
    description = "SSH from my IP" // It should be limited to your own IP or IP of public subnet
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.10.0.5/32"]  // Use IP of Bastion/Jumbbox Server
  }

  ingress {
    description = "HTTP from public subnet"  
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["10.10.0.0/24"]  //Use private ip of reverse proxy server
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-ws"
  }
}

# Imports the keypair
resource "aws_key_pair" "ws_ec2_key" {
  key_name   = "ws-ec2-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Creates the EC2 instance with Apache installed in Private subnet
resource "aws_instance" "web_server" {
  instance_type               = var.instance_type
  ami                         = var.ami_id
  key_name                    = aws_key_pair.ws_ec2_key.id
  vpc_security_group_ids      = [aws_security_group.sg_ws.id]
  subnet_id                   = aws_subnet.ongc_dev_private_subnet1.id
  #associate_public_ip_address = true
  user_data                   = file("web-server.tpl")

  root_block_device {
    volume_size = var.ebs_size
  }

  tags = {
    Name = "web-server"
  }
}
