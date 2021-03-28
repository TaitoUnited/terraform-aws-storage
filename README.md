# AWS storage

Example usage:

```
provider "aws" {
  region         = "us-east-1"
}

module "storage" {
  source          = "TaitoUnited/storage/aws"
  version         = "1.0.0"

  storage_buckets = yamldecode(file("${path.root}/../infra.yaml"))["storageBuckets"]
}
```

Example YAML:

```
storageBuckets:
  - name: zone1-state
    acl: private
    versioningEnabled: true
    versioningRetainDays: 90

  - name: zone1-backup
    acl: private
    versioningEnabled: false

  - name: zone1-temp
    acl: private
    versioningEnabled: false
    autoDeletionRetainDays: 60

  - name: zone1-public
    acl: public-read
    versioningEnabled: true
    versioningRetainDays: 60
    cors:
      - allowedOrigins: ["*"]
```

YAML attributes:

- See variables.tf for all the supported YAML attributes.

Combine with the following modules to get a complete infrastructure defined by YAML:

- [Admin](https://registry.terraform.io/modules/TaitoUnited/admin/aws)
- [DNS](https://registry.terraform.io/modules/TaitoUnited/dns/aws)
- [Network](https://registry.terraform.io/modules/TaitoUnited/network/aws)
- [Compute](https://registry.terraform.io/modules/TaitoUnited/compute/aws)
- [Kubernetes](https://registry.terraform.io/modules/TaitoUnited/kubernetes/aws)
- [Databases](https://registry.terraform.io/modules/TaitoUnited/databases/aws)
- [Storage](https://registry.terraform.io/modules/TaitoUnited/storage/aws)
- [Monitoring](https://registry.terraform.io/modules/TaitoUnited/monitoring/aws)
- [Integrations](https://registry.terraform.io/modules/TaitoUnited/integrations/aws)
- [PostgreSQL privileges](https://registry.terraform.io/modules/TaitoUnited/privileges/postgresql)
- [MySQL privileges](https://registry.terraform.io/modules/TaitoUnited/privileges/mysql)

Similar modules are also available for Azure, Google Cloud, and DigitalOcean. All modules are used by [infrastructure templates](https://taitounited.github.io/taito-cli/templates#infrastructure-templates) of [Taito CLI](https://taitounited.github.io/taito-cli/). TIP: See also [AWS project resources](https://registry.terraform.io/modules/TaitoUnited/project-resources/aws), [Full Stack Helm Chart](https://github.com/TaitoUnited/taito-charts/blob/master/full-stack), and [full-stack-template](https://github.com/TaitoUnited/full-stack-template).

Contributions are welcome!
