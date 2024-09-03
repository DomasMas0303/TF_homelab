resource "aws_key_pair" "epam_tf_ssh_key" {
  key_name   = "epam-tf-ssh-key"
  public_key = var.ssh_key

  tags = {
    Terraform = "true"
    Project   = "epam-tf-lab"
    Owner     = "${var.student_name}_${var.student_surname}"
  }
}