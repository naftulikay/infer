# IAM Resources

data "template_file" "replication_policy" {
  template = "${file("${path.module}/templates/replication-policy.json.tpl")}"

  vars = {
    primary_bucket_arn = "${aws_s3_bucket.primary.arn}"
    primary_kms_key_arn = "${aws_kms_key.primary.arn}"
    primary_region = "${var.primary_region}"
    replica_bucket_arn = "${aws_s3_bucket.replica.arn}"
    replica_kms_key_arn = "${aws_kms_key.replica.arn}"
    replica_region = "${var.replica_region}"
  }
}

resource "aws_iam_policy" "default" {
  name = "${var.group_name}-replication@${var.domain_name}"
  path = "/${var.domain_name}/"

  policy = "${data.template_file.replication_policy.rendered}"
}

resource "aws_iam_policy_attachment" "default" {
  name = "${var.group_name}-replication-attachment@${var.domain_name}"
  roles = ["${aws_iam_role.default.name}"]
  policy_arn = "${aws_iam_policy.default.arn}"
}

resource "aws_iam_role" "default" {
  name = "${var.group_name}-replication@${var.domain_name}"
  path = "/${var.domain_name}/"

  assume_role_policy = "${file("${path.module}/static/s3-assume-role.json")}"
}
