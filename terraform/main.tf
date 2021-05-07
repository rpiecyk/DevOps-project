terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = var.aws_region
}

resource "aws_vpc" "scalac-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = "true" 
  enable_dns_hostnames = "true"
  enable_classiclink = "false"
  instance_tenancy = "default"
  tags = {
    Name = "scalac-vpc"
  }
}

resource "aws_subnet" "scalac-subnet" {
  vpc_id = aws_vpc.scalac-vpc.id
  cidr_block = "10.0.100.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = var.az-first
  tags = {
    Name = "prod-subnet-public-1"
  }
}

resource "aws_route_table" "scalac-rt" {
  vpc_id = aws_vpc.scalac-vpc.id
  route {
    cidr_block = var.internet_cidr
    gateway_id = aws_internet_gateway.scalac-gw.id
  }
  tags = {
    Name = "scalac-rt"
  }
}

resource "aws_internet_gateway" "scalac-gw" {
  vpc_id = aws_vpc.scalac-vpc.id
  tags = {
    Name = "scalac-gw"
  }
}

resource "aws_route_table_association" "rt-ass-rt" {
  subnet_id = aws_subnet.scalac-subnet.id
  route_table_id = aws_route_table.scalac-rt.id
}

resource "aws_security_group" "scalac-pub" {
  name        = "public-sg"
  description = "Allow Ping, SSH and HTTP access for resources in public subnets"
  vpc_id      = aws_vpc.scalac-vpc.id

  ingress {
    description = "Allow ping"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.internet_cidr]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.internet_cidr]
  }

  ingress {
    description = "Allow access to Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.internet_cidr]
  }

  ingress {
    description = "Allow access to service 100jokes"
    from_port   = 8090
    to_port     = 8090
    protocol    = "tcp"
    cidr_blocks = [var.internet_cidr]
  }

  egress {
    description = "Allow ec to reach Internet - all ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.internet_cidr]
  }

  tags = {
    Name = "public-access-sg"
  }
}

resource "aws_key_pair" "scalac-ec2-key" {
  key_name = var.instance_key_name
  public_key = file(var.instance_key)
  tags = {
    Name = "scalac-ec2-key"
  }
}

resource "aws_instance" "Scalac" {
  ami = var.instance_ami
  instance_type = var.instance_type
  key_name = var.instance_key_name
  subnet_id = aws_subnet.scalac-subnet.id
  vpc_security_group_ids =  [aws_security_group.scalac-pub.id]
  associate_public_ip_address = true

  tags = {
    Name = var.instance_name
  }

  provisioner "remote-exec" {
    
    inline = [
      "sudo apt-get -f install",
      "python3 --version",
    ]

    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key)
    }
  }

  provisioner "local-exec" {

    command = <<EOT
      ansible-playbook -vv \
        --ssh-common-args='-o StrictHostKeyChecking=no' \
        -i '${self.public_ip},' \
        -u ubuntu \
        --private-key ${var.private_key} \
        ../ansible/prepare_ec2.yaml
    EOT
  }
}
