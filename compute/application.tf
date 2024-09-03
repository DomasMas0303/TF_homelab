# Data source for the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_launch_template" "epam_tf_lab" {
  name          = "epam-tf-lab"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"

  key_name = data.aws_key_pair.ssh_key.key_name

  iam_instance_profile {
    name = data.aws_iam_instance_profile.instance_profile.name
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups = [
      data.aws_security_group.ssh.id,
      data.aws_security_group.http.id
    ]
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    COMPUTE_MACHINE_UUID=$(cat /sys/devices/virtual/dmi/id/product_uuid | tr '[:upper:]' '[:lower:]')
    COMPUTE_INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
    echo "This message was generated on instance $COMPUTE_INSTANCE_ID with the following UUID $COMPUTE_MACHINE_UUID" | aws s3 cp - s3://${data.aws_s3_bucket.lab_bucket.id}/$COMPUTE_INSTANCE_ID.txt
  EOF
  )

  tags = {
    Terraform = "true"
    Project   = "epam-tf-lab"
    Owner     = "${var.student_name}_${var.student_surname}"
  }
}

# Create an Auto Scaling Group
resource "aws_autoscaling_group" "epam_tf_lab" {
  name                = "epam-tf-lab"
  max_size            = 1
  min_size            = 1
  desired_capacity    = 1
  vpc_zone_identifier = data.aws_subnets.public.ids

  launch_template {
    id      = aws_launch_template.epam_tf_lab.id
    version = "$Latest"
  }

  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = "epam-tf-lab"
    propagate_at_launch = true
  }

  tag {
    key                 = "Owner"
    value               = "${var.student_name}_${var.student_surname}"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }
}

# Create an Application Load Balancer
resource "aws_lb" "epam_tf_lab" {
  name               = "elb-epam-tf-lab"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.http_lb.id]
  subnets            = data.aws_subnets.public.ids

  tags = {
    Terraform = "true"
    Project   = "epam-tf-lab"
    Owner     = "${var.student_name}_${var.student_surname}"
  }
}

# Create a target group for the ALB
resource "aws_lb_target_group" "epam_tf_lab" {
  name     = "tg-epam-tf-lab"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.main.id

  health_check {
    path = "/"
    port = 80
  }
}

# Create a listener for the ALB
resource "aws_lb_listener" "epam_tf_lab" {
  load_balancer_arn = aws_lb.epam_tf_lab.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.epam_tf_lab.arn
  }
}

# Attach the Auto Scaling Group to the ALB
resource "aws_autoscaling_attachment" "epam_tf_lab" {
  autoscaling_group_name = aws_autoscaling_group.epam_tf_lab.name
  lb_target_group_arn    = aws_lb_target_group.epam_tf_lab.arn
}