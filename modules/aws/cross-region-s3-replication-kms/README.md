# Cross-Region, Versioned, KMS-Encrypted S3 Replication

This module sets up a pair of S3 buckets in two regions, with the primary replicating to the secondary, while using
bucket versioning, and while using region-specific KMS keys to perform serverside encryption. Whew, that was a
mouthful. How about in bullet points?

 - A primary S3 bucket in one region.
 - A secondary S3 bucket in another region.
 - A KMS key in the primary region.
 - A KMS key in the secondary region.
 - Object versioning on both buckets.
 - Lifecycle rules galore for cost-savings.
 - An IAM policy for replication to allow the replication and encryption.
