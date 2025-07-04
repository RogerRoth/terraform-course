output "instance_public_ips" {
  description = "Public IP addresses of EC2 instances in us-east-1"
  value       = aws_instance.web-east-1[*].public_ip
}

output "instance_ids" {
  description = "Instance IDs of EC2 instances in us-east-1"
  value       = aws_instance.web-east-1[*].id
}

output "instance_private_ips" {
  description = "Private IP addresses of EC2 instances in us-east-1"
  value       = aws_instance.web-east-1[*].private_ip
}
