{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "SourceBucketMetadata",
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${primary_bucket_arn}"
      ]
    },
    {
      "Sid": "SourceBucketObjectMetadata",
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl",
        "s3:GetObjectVersionTagging",
        "s3:GetObjectVersionForReplication"
      ],
      "Effect": "Allow",
      "Resource": [
        "${primary_bucket_arn}/*"
      ]
    },
    {
      "Sid": "ReplicateToDestinationBucket",
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags"
      ],
      "Effect": "Allow",
      "Resource": [
        "${replica_bucket_arn}/*"
      ]
    },
    {
      "Sid": "DecryptSourceObjects",
      "Action": ["kms:Decrypt"],
      "Effect": "Allow",
      "Condition": {
        "StringLike": {
          "kms:ViaService": "s3.${primary_region}.amazonaws.com",
          "kms:EncryptionContext:aws:s3:arn": [
            "${primary_bucket_arn}/*"
          ]
        }
      },
      "Resource": [
        "${primary_kms_key_arn}"
      ]
    },
    {
      "Sid": "EncryptDestinationObjects",
      "Action": ["kms:Encrypt"],
      "Effect": "Allow",
      "Condition": {
        "StringLike": {
          "kms:ViaService": "s3.${replica_region}.amazonaws.com",
          "kms:EncryptionContext:aws:s3:arn": [
            "${replica_bucket_arn}/*"
          ]
        }
      },
      "Resource": [
        "${replica_kms_key_arn}"
      ]
    }
  ]
}
