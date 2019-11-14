# Outputs

output "iam_replication_policy_arn" { value = "${aws_iam_policy.default.arn}" }
output "iam_replication_role_arn" { value = "${aws_iam_role.default.arn}" }
output "primary_bucket" { value = "${aws_s3_bucket.primary.bucket}" }
output "primary_kms_key_arn" { value = "${aws_kms_key.primary.arn}" }
output "replica_bucket" { value = "${aws_s3_bucket.replica.bucket}" }
output "replica_kms_key_arn" { value = "${aws_kms_key.replica.arn}" }
