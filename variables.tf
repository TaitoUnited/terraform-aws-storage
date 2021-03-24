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

# TODO: Not all attributes have been implemented
variable "storage_buckets" {
  type = list(object({
    name = string
    purpose = optional(string)
    acl = string
    storageClass = optional(string)
    cors = list(object({
      allowedOrigins = list(string)
      allowedMethods = optional(list(string))
      allowedHeaders = optional(list(string))
      exposeHeaders = optional(list(string))
      maxAgeSeconds = optional(number)
    }))
    versioningEnabled = bool
    versioningRetainDays = optional(number)
    # TODO: lockRetainDays = optional(number)
    transitionRetainDays = optional(number)
    transitionStorageClass = optional(string)
    autoDeletionRetainDays = optional(number)
    # TODO: replicationBucket = optional(string)
    # TODO: backupRetainDays = optional(number)
    # TODO: backupLocation = optional(string)
    # TODO: backupLock = optional(bool)
    # TODO:
    # members = list(object({
    #   id = string
    #   roles = list(string)
    # }))
  }))
  default     = []
  description = "Resources as JSON (see README.md). You can read values from a YAML file with yamldecode()."
}
