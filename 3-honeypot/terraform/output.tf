output "vpc_id" {
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  value       = aws_subnet.public.id
}

output "ec2_public_ip" {
  value = aws_instance.this.public_ip
}
