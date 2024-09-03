resource "aws_s3_bucket" "epam_tf_lab" {
  bucket = "task9-domas-test-1337"
  tags = {
    Terraform = "true"
    Project   = "epam-tf-lab"
    Owner     = "${var.student_name}_${var.student_surname}"
  }
}

resource "aws_s3_bucket_ownership_controls" "epam_tf_lab" {
  bucket = aws_s3_bucket.epam_tf_lab.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "epam_tf_lab" {
  bucket                  = aws_s3_bucket.epam_tf_lab.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "epam_tf_lab" {
  depends_on = [
    aws_s3_bucket_ownership_controls.epam_tf_lab,
    aws_s3_bucket_public_access_block.epam_tf_lab,
  ]
  bucket = aws_s3_bucket.epam_tf_lab.id
  acl    = "private"
}