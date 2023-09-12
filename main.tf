provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "MyVPC-1"
  }
}

resource "aws_subnet" "main" {
  cidr_block        = var.subnet_cidr_block
  vpc_id            = aws_vpc.main.id
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "MySubnet-1"
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

resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.main.id
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
    cidr_blocks = ["0.0.0.0/0"] # You may want to restrict this to your IP or specific IPs for security
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # You may want to restrict this to your IP or specific IPs for security
  }

  // Define your security group rules here
}

resource "aws_instance" "main" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.main.id
  tags = {
    Name = var.route_table_name
  }
  vpc_security_group_ids = [aws_security_group.main.id]
  tags = {
    Name = "MyEC2Instance-1"
  }

  // Add any other necessary configuration for your instance
}

resource "aws_s3_bucket" "main" {
  bucket = var.s3_bucket_name
  acl    = "private"
}

resource "aws_iam_policy" "s3_bucket_policy" {
  name        = "s3_bucket_policyyy"
  description = "IAM policy for granting access to S3 bucket"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["s3:GetObject"],
        Effect   = "Allow",
        Resource = aws_s3_bucket.main.arn # Construct ARN using bucket name
      },
      {
        Action   = ["s3:ListBucket"],
        Effect   = "Allow",
        Resource = "${aws_s3_bucket.main.arn}/*" # Construct ARN for bucket contents
      }
    ],
  })
}

resource "aws_iam_policy_attachment" "s3_bucket_attachment" {
  name       = "s3_bucket_attachment"
  policy_arn = aws_iam_policy.s3_bucket_policy.arn
  users      = ["terraform-user"] # Replace with your IAM user
}

resource "aws_iam_user" "example_user" {
  name = var.iam_user_name
}

resource "aws_iam_role" "example_role" {
  name = var.iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com" # Modify to match your use case
        }
      }
    ]
  })
}
