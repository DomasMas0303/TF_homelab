# Security Group for SSH access
resource "aws_security_group" "ssh_inbound" {
  name        = "ssh-inbound"
  description = "Allows SSH access from safe IP-range"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from safe IP range"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ip_range]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "ssh-inbound"
  })
}

# Security Group for Load Balancer HTTP access
resource "aws_security_group" "lb_http_inbound" {
  name        = "lb-http-inbound"
  description = "Allows HTTP access from safe IP-range to a LoadBalancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from safe IP range"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ip_range]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "lb-http-inbound"
  })
}

# Security Group for HTTP access from Load Balancer
resource "aws_security_group" "http_inbound" {
  name        = "http-inbound"
  description = "Allows HTTP access from LoadBalancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "HTTP from Load Balancer"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_http_inbound.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "http-inbound"
  })
}