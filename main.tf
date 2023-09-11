provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

}

resource "aws_subnet" "main" {
  cidr_block     = var.subnet_cidr_block
  vpc_id         = aws_vpc.main.id
  availability_zone = "${var.aws_region}a"
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_security_group" "main" {
  name        = "example_security_group"
  description = "Example Security Group"
  vpc_id      = aws_vpc.main.id

  // Define your security group rules here
}

resource "aws_instance" "main" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.main.id]


  // Add any other necessary configuration for your instance
}

resource "aws_s3_bucket" "main" {
  bucket = var.s3_bucket_name
  acl    = "private"  # Adjust access controls as needed
}
