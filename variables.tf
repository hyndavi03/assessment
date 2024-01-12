# variables.tf

variable "aws_region" {
  description = "AWS region where resources will be created."
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC."
  default     = "11.0.0.0/16"
}

variable "development_subnet_cidr_block" {
  description = "CIDR block for the Development subnet."
  default     = "11.0.1.0/24"
}

variable "production_subnet_cidr_block" {
  description = "CIDR block for the Production subnet."
  default     = "11.0.2.0/24"
}

variable "route_table_name" {
  description = "Name for the AWS route table."
  default     = "RT" # Set the desired name here
}

variable "instance_type" {
  description = "EC2 instance type."
  default     = "t2.micro"
}

variable "instance_ami" {
  description = "AMI ID for the EC2 instance."
  default     = "ami-0005e0cfe09cc9050"
}


variable "security_group_ingress" {
  description = "Ingress rule for the security group."
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

