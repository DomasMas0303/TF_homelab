variable "student_name" {
  type    = string
  default = "Domas"
}

variable "student_surname" {
  type    = string
  default = "Masevicius"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.3.0/24", "10.10.5.0/24"]
}

variable "ssh_key" {
  description = "Provides custom public ssh key"
  type        = string
  sensitive   = true
}

variable "allowed_ip_range" {
  description = "The IP range allowed for SSH and HTTP access"
  type        = string
  default     = "84.15.186.123/32"
}