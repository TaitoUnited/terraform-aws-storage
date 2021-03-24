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

locals {
  storageBuckets = var.storage_buckets

  /* TODO: implement CDN
  cdnStorageBuckets = flatten([
    for bucket in local.storageBuckets:
    bucket.cdnDomain != null && bucket.cdnDomain != "" ? [ bucket ] : []
  ])
  */

  /* TODO: implement members
  storageBucketMembers = flatten([
    for bucket in local.storageBuckets: [
      for member in (bucket.members != null ? bucket.members : []): [
        for role in try(member.roles != null ? member.roles : []):
        {
          key    = "${bucket.name}-${member.id}-${role}"
          bucket = bucket.name
          member = member.id
          role = role
        }
      ]
    ]
  ])
  */
}
