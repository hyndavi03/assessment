output "vpc_id" {
  value = aws_vpc.main.id
}

output "development_subnet_id" {
  value = aws_subnet.development_subnet.id
}

output "production_subnet_id" {
  value = aws_subnet.production_subnet.id
}

output "development_instance_id" {
  value = aws_instance.development_instance.id
}

output "production_instance_id" {
  value = aws_instance.production_instance.id
}

