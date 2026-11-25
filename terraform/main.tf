
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_vpc" "drupal_vpc" {
  cidr_block           = "10.20.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "drupal-ha-vpc"
  }
}

resource "aws_internet_gateway" "drupal_igw" {
  vpc_id = aws_vpc.drupal_vpc.id

  tags = {
    Name = "drupal-ha-igw"
  }
}

resource "aws_subnet" "public" {
  count = 2

  vpc_id                  = aws_vpc.drupal_vpc.id
  cidr_block              = ["10.20.1.0/24", "10.20.2.0/24"][count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "drupal-public-${count.index + 1}"
  }
}

resource "aws_subnet" "private_app" {
  count = 2

  vpc_id            = aws_vpc.drupal_vpc.id
  cidr_block        = ["10.20.11.0/24", "10.20.12.0/24"][count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "drupal-private-app-${count.index + 1}"
  }
}

resource "aws_subnet" "private_db" {
  count = 2

  vpc_id            = aws_vpc.drupal_vpc.id
  cidr_block        = ["10.20.21.0/24", "10.20.22.0/24"][count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "drupal-private-db-${count.index + 1}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.drupal_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.drupal_igw.id
  }

  tags = {
    Name = "drupal-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count = 2

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  count  = 2
  domain = "vpc"

  tags = {
    Name = "drupal-nat-eip-${count.index + 1}"
  }
}

resource "aws_nat_gateway" "drupal_nat" {
  count = 2

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  depends_on = [aws_internet_gateway.drupal_igw]

  tags = {
    Name = "drupal-nat-${count.index + 1}"
  }
}

resource "aws_route_table" "private_app" {
  count = 2

  vpc_id = aws_vpc.drupal_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.drupal_nat[count.index].id
  }

  tags = {
    Name = "drupal-private-app-rt-${count.index + 1}"
  }
}

resource "aws_route_table_association" "private_app" {
  count = 2

  subnet_id      = aws_subnet.private_app[count.index].id
  route_table_id = aws_route_table.private_app[count.index].id
}

resource "aws_security_group" "app" {
  name        = "drupal-app-sg"
  description = "Drupal application servers - HTTP from ALB only"
  vpc_id      = aws_vpc.drupal_vpc.id

  ingress {
    description     = "HTTP from load balancer"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "drupal-app-sg"
  }
}

resource "aws_security_group" "alb" {
  name        = "drupal-alb-sg"
  description = "Public HTTP and HTTPS access"
  vpc_id      = aws_vpc.drupal_vpc.id

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "drupal-alb-sg"
  }
}

resource "aws_security_group" "database" {
  name        = "drupal-db-sg"
  description = "MySQL access from Drupal application servers"
  vpc_id      = aws_vpc.drupal_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  tags = {
    Name = "drupal-db-sg"
  }
}
