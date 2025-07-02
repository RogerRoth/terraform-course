output "instance_public_ip" {
  value = aws_instance.web-east-1.public_ip
}

output "instance_public_ip_west-2" {
  value = aws_instance.web-west-2.public_ip
}