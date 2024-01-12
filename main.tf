# main.tf

provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "MyVPC-1"
  }
}

resource "aws_subnet" "development_subnet" {
  cidr_block        = var.development_subnet_cidr_block
  vpc_id            = aws_vpc.main.id
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "DevelopmentSubnet"
  }
  map_public_ip_on_launch = true
}

resource "aws_subnet" "production_subnet" {
  cidr_block        = var.production_subnet_cidr_block
  vpc_id            = aws_vpc.main.id
  availability_zone = "${var.aws_region}b"  # Use a different availability zone for production
  tags = {
    Name = "ProductionSubnet"
  }
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "MyIGW-1"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route" "internet" {
  route_table_id         = aws_route_table.main.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "development_association" {
  subnet_id      = aws_subnet.development_subnet.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "production_association" {
  subnet_id      = aws_subnet.production_subnet.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "main" {
  name        = "example_security_group"
  description = "Example Security Group"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "MySG-1"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "development_instance" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.development_subnet.id
  vpc_security_group_ids = [aws_security_group.main.id]
  tags = {
    Name = "Development"
  }
}

resource "aws_instance" "production_instance" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.production_subnet.id
  vpc_security_group_ids = [aws_security_group.main.id]
  tags = {
    Name = "Production"
  }
}

