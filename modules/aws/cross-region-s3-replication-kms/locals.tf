# Local Variables

locals {
  primary_bucket_name = "${var.group_name}-${var.primary_region}"
  replica_bucket_name = "${var.group_name}-${var.replica_region}"
}
