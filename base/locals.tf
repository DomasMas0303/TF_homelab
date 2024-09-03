locals {
  vpc_name = "${var.student_name}-${var.student_surname}-01-vpc"

  availability_zones = ["a", "b", "c"]
  public_subnet_names = [
    "${var.student_name}-${var.student_surname}-01-subnet-public-a",
    "${var.student_name}-${var.student_surname}-01-subnet-public-b",
    "${var.student_name}-${var.student_surname}-01-subnet-public-c"
  ]

  igw_name         = "${var.student_name}-${var.student_surname}-01-igw"
  route_table_name = "${var.student_name}-${var.student_surname}-01-rt"

  common_tags = {
    Terraform = "true"
    Project   = "epam-tf-lab"
    Owner     = "${var.student_name}_${var.student_surname}"
  }
}