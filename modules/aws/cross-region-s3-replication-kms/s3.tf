# S3 Resources

resource "aws_s3_bucket" "primary" {
  bucket = "${local.primary_bucket_name}"
  acl = "private"

  force_destroy = "${var.volatile}"

  region = "${var.primary_region}"

  lifecycle_rule {
    enabled = true

    transition {
      # immediately transition to infrequent access
      days = 30
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_transition {
      # non-current versions go to deep archive in 30 days
      days = 60
      storage_class = "DEEP_ARCHIVE"
    }

    noncurrent_version_expiration {
      # non-current versions expire after one year
      days = 365
    }
  }

  replication_configuration {
    role = "${aws_iam_role.default.arn}"

    rules {
      id = "${local.replica_bucket_name}"
      status = "Enabled"

      destination {
        bucket = "${aws_s3_bucket.replica.arn}"
        storage_class = "DEEP_ARCHIVE"
        replica_kms_key_id = "${aws_kms_key.replica.arn}"
      }

      source_selection_criteria {
        sse_kms_encrypted_objects {
          enabled = true
        }
      }
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.primary.id}"
        sse_algorithm = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  tags = {
    Name = "${local.primary_bucket_name}"
    role = "primary"
    group = "${var.group_name}"
  }
}

resource "aws_s3_bucket_public_access_block" "primary" {
  bucket = "${aws_s3_bucket.primary.bucket}"

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "replica" {
  provider = "aws.replica"

  bucket = "${local.replica_bucket_name}"
  acl = "private"

  force_destroy = "${var.volatile}"

  region = "${var.replica_region}"

  lifecycle_rule {
    enabled = true

    transition {
      # everything goes immediately to glacier deep archive
      days = 30
      storage_class = "DEEP_ARCHIVE"
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.replica.id}"
        sse_algorithm = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  tags = {
    Name = "${local.replica_bucket_name}"
    role = "replica"
    group = "${var.group_name}"
  }
}

resource "aws_s3_bucket_public_access_block" "replica" {
  provider = "aws.replica"

  bucket = "${aws_s3_bucket.replica.bucket}"

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}
