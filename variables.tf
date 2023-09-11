variable "aws_region" {
  description = "AWS region where resources will be created."
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC."
  default     = "11.0.0.0/16"
}

variable "subnet_cidr_block" {
  description = "CIDR block for the subnet."
  default     = "11.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type."
  default     = "t2.micro"
}

variable "instance_ami" {
  description = "AMI ID for the EC2 instance."
  default     = "ami-01c647eace872fc02" 
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket."
  default     = "my-terraform-bucket0101"
}

variable "security_group_ingress" {
  description = "Ingress rule for the security group."
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
