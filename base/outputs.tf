output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "security_group_id_ssh" {
  description = "ID of the security group allowing SSH access"
  value       = aws_security_group.ssh_inbound.id
}

output "security_group_id_http" {
  description = "ID of the security group allowing HTTP access from the load balancer"
  value       = aws_security_group.http_inbound.id
}

output "security_group_id_http_lb" {
  description = "ID of the security group allowing HTTP access to the load balancer"
  value       = aws_security_group.lb_http_inbound.id
}

output "iam_instance_profile_name" {
  description = "Name of the IAM instance profile"
  value       = aws_iam_instance_profile.epam_profile.name
}

output "key_name" {
  description = "Name of the SSH key pair"
  value       = aws_key_pair.epam_tf_ssh_key.key_name
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.epam_tf_lab.id
}

output "student_name" {
  value = var.student_name
}

output "student_surname" {
  value = var.student_surname
}