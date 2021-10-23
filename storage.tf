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
  acl      = coalesce(each.value.acl, "private")
  policy   = each.value.acl == "public-read" ? data.aws_iam_policy_document.publicassets[each.key].json : null

  tags = merge(local.tags, {
    purpose = each.value.purpose
  })

  dynamic "cors_rule" {
    for_each = coalesce(each.value.corsRules, null) != null ? each.value.corsRules : []
    content {
      allowed_origins  = cors_rule.value.allowedOrigins
      allowed_methods  = coalesce(cors_rule.value.allowedMethods, ["GET","HEAD"])
      allowed_headers  = coalesce(cors_rule.value.allowedHeaders, ["*"])
      expose_headers   = coalesce(cors_rule.value.exposeHeaders, ["*"])
      max_age_seconds  = coalesce(cors_rule.value.maxAgeSeconds, 5)
    }
  }

  versioning {
    enabled = coalesce(each.value.versioningEnabled, false)
  }

  lifecycle_rule {
    id = "storageClass"
    enabled = (
      coalesce(each.value.storageClass, null) != null
      && coalesce(each.value.storageClass, null) != "STANDARD_IA"
    )
    transition {
      days = 0
      storage_class = (
        coalesce(each.value.storageClass, null) != null
        && coalesce(each.value.storageClass, null) != "STANDARD_IA"
          ? coalesce(each.value.storageClass, null)
          : "GLACIER"
      )
    }
  }

  lifecycle_rule {
    id = "transition"
    enabled = coalesce(each.value.transitionRetainDays, null) != null
    transition {
      days = coalesce(each.value.transitionRetainDays, null)
      storage_class = (
        coalesce(each.value.transitionStorageClass, null) != null
          ? coalesce(each.value.transitionStorageClass, null)
          : "GLACIER"
      )
    }
  }

  lifecycle_rule {
    id = "versioning"
    enabled = coalesce(each.value.versioningRetainDays, null) != null
    noncurrent_version_expiration {
      days = coalesce(each.value.versioningRetainDays, null)
    }
  }

  lifecycle_rule {
    id = "autoDeletion"
    enabled = coalesce(each.value.autoDeletionRetainDays, null) != null
    expiration {
      days = coalesce(each.value.autoDeletionRetainDays, null)
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
