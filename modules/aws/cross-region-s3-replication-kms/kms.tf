# KMS Resources

# kms keys are regional, hence we create one per region for DR purposes
resource "aws_kms_key" "primary" {
  description = "Long-term backup encryption key for ${var.group_name} in ${var.primary_region}."
  deletion_window_in_days = "${var.volatile ? 7 : 30}"
  enable_key_rotation = true

  tags = {
    Name = "${var.group_name}-${var.primary_region}"
    group = "${var.group_name}"
    role = "primary"
  }
}

resource "aws_kms_key" "replica" {
  provider = "aws.replica"

  description = "Long-term backup encryption key for ${var.group_name} in ${var.replica_region}."
  deletion_window_in_days = "${var.volatile ? 7 : 30}"
  enable_key_rotation = true

  tags = {
    Name = "${var.group_name}-${var.replica_region}"
    group = "${var.group_name}"
    role = "replica"
  }
}
