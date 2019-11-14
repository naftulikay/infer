# Variables

variable "domain_name" {}

variable "group_name" {
  description = <<-EOF
    A prefix for bucket naming. A hyphen will automatically be inserted between the bucket prefix and the region used
    to name buckets and resources.
  EOF
}

variable "primary_region" {}
variable "replica_region" {}

variable "volatile" { default = false }
