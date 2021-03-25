/**
 * Copyright 2021 Taito United
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

resource "aws_s3_bucket" "bucket" {
  for_each = {for item in local.storageBuckets: item.name => item}

  bucket   = each.value.name
  acl      = each.value.acl
  policy   = each.value.acl == "public-read" ? data.aws_iam_policy_document.publicassets[each.key].json : null

  tags = merge(local.tags, {
    purpose = each.value.purpose
  })

  dynamic "cors_rule" {
    for_each = try(each.value.cors, null) != null ? each.value.cors : []
    content {
      allowed_origins  = cors.value.allowedOrigins
      allowed_methods  = cors.value.allowedMethods
      allowed_headers  = cors.value.allowedHeaders
      expose_headers   = cors.value.exposeHeaders
      max_age_seconds  = cors.value.maxAgeSeconds
    }
  }

  versioning {
    enabled = each.value.versioningEnabled
  }

  lifecycle_rule {
    id = "storageClass"
    enabled = (
      try(each.value.storageClass, null) != null
      && try(each.value.storageClass, null) != "STANDARD_IA"
    )
    transition {
      days = 0
      storage_class = (
        try(each.value.storageClass, null) != null
        && try(each.value.storageClass, null) != "STANDARD_IA"
          ? try(each.value.storageClass, null)
          : "GLACIER"
      )
    }
  }

  lifecycle_rule {
    id = "transition"
    enabled = try(each.value.transitionRetainDays, null) != null
    transition {
      days = try(each.value.transitionRetainDays, null)
      storage_class = (
        try(each.value.transitionStorageClass, null) != null
          ? try(each.value.transitionStorageClass, null)
          : "GLACIER"
      )
    }
  }

  lifecycle_rule {
    id = "versioning"
    enabled = try(each.value.versioningRetainDays, null) != null
    noncurrent_version_expiration {
      days = try(each.value.versioningRetainDays, null)
    }
  }

  lifecycle_rule {
    id = "autoDeletion"
    enabled = try(each.value.autoDeletionRetainDays, null) != null
    expiration {
      days = try(each.value.autoDeletionRetainDays, null)
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

data "aws_iam_policy_document" "publicassets" {
  for_each = {for item in local.storageBuckets: item.name => item}
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::${each.value.name}",
      "arn:aws:s3:::${each.value.name}/*"
    ]
  }
}
