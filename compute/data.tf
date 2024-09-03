# Data source for the VPC created in base configuration
data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["${var.student_name}-${var.student_surname}-01-vpc"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  filter {
    name   = "tag:Name"
    values = ["${var.student_name}-${var.student_surname}-01-subnet-public-*"]
  }
}

data "aws_security_group" "ssh" {
  name   = "ssh-inbound"
  vpc_id = data.aws_vpc.main.id
}

data "aws_security_group" "http" {
  name   = "http-inbound"
  vpc_id = data.aws_vpc.main.id
}

data "aws_security_group" "http_lb" {
  name   = "lb-http-inbound"
  vpc_id = data.aws_vpc.main.id
}

# Fetch the IAM instance profile
data "aws_iam_instance_profile" "instance_profile" {
  name = "${var.student_name}-${var.student_surname}-01-profile"
}

# Fetch the key pair
data "aws_key_pair" "ssh_key" {
  key_name = "epam-tf-ssh-key"
}

data "aws_s3_bucket" "lab_bucket" {
  bucket = "task9-domas-test-1337"
}

# Output these values for reference
output "vpc_id" {
  value = data.aws_vpc.main.id
}

output "public_subnet_ids" {
  value = data.aws_subnets.public.ids
}

output "security_group_id_ssh" {
  value = data.aws_security_group.ssh.id
}

output "security_group_id_http" {
  value = data.aws_security_group.http.id
}

output "security_group_id_http_lb" {
  value = data.aws_security_group.http_lb.id
}

output "iam_instance_profile_name" {
  value = data.aws_iam_instance_profile.instance_profile.name
}

output "key_name" {
  value = data.aws_key_pair.ssh_key.key_name
}

output "s3_bucket_name" {
  value = data.aws_s3_bucket.lab_bucket.id
}