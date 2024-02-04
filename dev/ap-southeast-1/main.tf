terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

# Configure AWS VPC disini
resource "aws_vpc" "main" {
  cidr_block = "192.168.1.0/24"
  tags ={
    Name = var.tag_name
    Project = var.tag_project
  }
}

# Configure Subnet untuk VPC disini
# 192.168.1.0 
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "192.168.1.0/24"

  tags ={
    Name = "devops-showcase-jan2024-pub-subnet"
    Project = "devops-showcase-jan2024"
  }
}

# Configure Internet Gateway untuk disini
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags ={
    Name = "devops-showcase-jan2024-igw"
    Project = "devops-showcase-jan2024"
  }

}

# Configure Route Table untuk Subnet disini
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name    = "devops-showcase-jan2024-route-table"
    Project = "devops-showcase-jan2024"
  }
}

# Configure Route Table Association untuk Subnet disini
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-showcase-jan2024-security-group"
    Project = "devops-showcase-jan2024"
  }
}


resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "devops-showcase-jan2024-key"
  public_key = tls_private_key.example.public_key_openssh

  lifecycle {
    create_before_destroy = true
  }
}

resource "local_file" "tf-key" {
  content = tls_private_key.example.private_key_pem
  filename = "devops-showcase-jan2024-key.pem"
}

resource "aws_instance" "web" {
  count         = 2
  ami           = "ami-09f9959f1d4217e63" # This is the ID for Rocky Linux 8.4 in us-west-2
  instance_type = "t3.small"
  subnet_id     = aws_subnet.main.id
  vpc_security_group_ids = [
    aws_security_group.allow_all.id
  ]
  key_name      = aws_key_pair.generated_key.key_name
  associate_public_ip_address = true


#  # Configure default EBS disini
#   root_block_device {
#     volume_size = 20 # Size in GB
#     volume_type = "gp2"
#     delete_on_termination = true
#   }

  tags = {
    Name = "devops-showcase-jan2024-web-${count.index}"
    Project = "devops-showcase-jan2024"
  }
}

resource "aws_elb" "lb" {
  name               = "lb"
  subnets            = [aws_subnet.main.id]
  security_groups    = [aws_security_group.allow_all.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  instances          = aws_instance.web[*].id

  tags = {
    Name = "devops-showcase-jan2024-elb"
    Project = "devops-showcase-jan2024"
  }
}