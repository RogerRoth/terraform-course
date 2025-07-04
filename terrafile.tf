module "servers" {
  source  = "./servers"
  instance_count = 1
  instance_type = "t2.micro"

  providers = {
    aws.east-1 = aws.east-1
  }
}

output "instance_public_ips" {
  description = "Public IP addresses of EC2 instances in us-east-1"
  value       = module.servers.instance_public_ips
}

output "instance_ids" {
  description = "Instance IDs of EC2 instances in us-east-1"
  value       = module.servers.instance_ids
}

output "instance_private_ips" {
  description = "Private IP addresses of EC2 instances in us-east-1"
  value       = module.servers.instance_private_ips
}
