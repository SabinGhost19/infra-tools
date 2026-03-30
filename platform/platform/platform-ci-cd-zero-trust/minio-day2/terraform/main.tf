terraform {
  required_version = ">= 1.3.0, < 2.0.0"
  required_providers {
    minio = {
      source  = "aminueza/minio"
      version = "~> 3.0"
    }
  }
}

locals {
  minio_server   = "harbor-storage-hl.minio-tenant.svc.cluster.local:9000"
  minio_user     = "minioadmin"
  minio_password = "MinioConsolePass-2026-Demo"
}

provider "minio" {
  minio_server   = local.minio_server
  minio_user     = local.minio_user
  minio_password = local.minio_password
  minio_ssl      = false
}

resource "minio_s3_bucket" "harbor_storage" {
  bucket = "harbor-storage"
  acl    = "private"
}

resource "minio_iam_user" "harbor_registry_robot" {
  name          = "harbor-registry-robot"
  secret        = "HarborRobotPass-2026-Demo"
  force_destroy = true
}

resource "minio_iam_policy" "harbor_storage_rw" {
  name = "harbor-storage-rw"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetBucketLocation",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads"
        ]
        Resource = [
          "arn:aws:s3:::harbor-storage"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:AbortMultipartUpload",
          "s3:GetObject",
          "s3:ListMultipartUploadParts",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::harbor-storage/*"
        ]
      }
    ]
  })
}

resource "minio_iam_user_policy_attachment" "harbor_registry_robot_policy" {
  user_name   = minio_iam_user.harbor_registry_robot.name
  policy_name = minio_iam_policy.harbor_storage_rw.name
}
