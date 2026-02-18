# redis

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1](https://img.shields.io/badge/AppVersion-1-informational?style=flat-square)

A Helm chart for redis (dev)on OpenShift

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| image.repository | string | `"registry.redhat.io/rhel9/redis-7"` |  |
| image.tag | string | `"latest"` |  |
| monitor | bool | `true` |  |
| redis.password | string | `"redhat01"` |  |
| resources.limits.memory | string | `"512Mi"` |  |
| service.port | int | `6379` |  |

