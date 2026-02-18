# postgresql

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1](https://img.shields.io/badge/AppVersion-1-informational?style=flat-square)

A Helm chart for postgresql (dev) on OpenShift

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| image.repository | string | `"registry.redhat.io/rhel9/postgresql-15"` |  |
| image.tag | string | `"latest"` |  |
| monitor | bool | `true` |  |
| postgresql.adminPassword | object | `{}` |  |
| postgresql.database | string | `"sampledb"` |  |
| postgresql.logDestination | string | `"/dev/stderr"` |  |
| postgresql.password | object | `{}` |  |
| postgresql.user | object | `{}` |  |
| resources.limits.cpu | object | `{}` |  |
| resources.limits.memory | string | `"512Mi"` |  |
| resources.requests.cpu | object | `{}` |  |
| resources.requests.memory | object | `{}` |  |
| service.port | int | `5432` |  |
| storage.size | string | `"1Gi"` |  |
| storage.storageClass | string | `"ocs-storagecluster-ceph-rbd"` |  |

