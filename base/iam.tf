# IAM Group
resource "aws_iam_group" "epam_group" {
  name = "${var.student_name}-${var.student_surname}-01-group"
}

# IAM Policy
resource "aws_iam_policy" "epam_tf_lab" {
  name        = "epam-tf-lab"
  path        = "/"
  description = "IAM policy for writing to epam-tf-lab S3 bucket"

  policy = templatefile("${path.module}/files/s3_write_policy.json", {
    bucket_name = aws_s3_bucket.epam_tf_lab.id
  })

  tags = {
    Terraform = "true"
    Project   = "epam-tf-lab"
    Owner     = "${var.student_name}_${var.student_surname}"
  }
}

# IAM Role
resource "aws_iam_role" "epam_role" {
  name = "${var.student_name}-${var.student_surname}-01-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Terraform = "true"
    Project   = "epam-tf-lab"
    Owner     = "${var.student_name}_${var.student_surname}"
  }
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "epam_policy_attach" {
  role       = aws_iam_role.epam_role.name
  policy_arn = aws_iam_policy.epam_tf_lab.arn
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "epam_profile" {
  name = "${var.student_name}-${var.student_surname}-01-profile"
  role = aws_iam_role.epam_role.name

  tags = {
    Terraform = "true"
    Project   = "epam-tf-lab"
    Owner     = "${var.student_name}_${var.student_surname}"
  }
}
