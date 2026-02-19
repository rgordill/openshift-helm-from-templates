# OpenShift Helm Charts

Helm charts for deploying workloads on OpenShift. Each chart is built from templates and default values suitable for development and integration with OpenShift (OCP) features such as OCS storage and ServiceMonitor.

## Charts

| Chart | Description |
|-------|-------------|
| [postgresql](charts/postgresql/) | PostgreSQL 15 (RHEL9 image) with persistent storage and optional ServiceMonitor |
| [redis](charts/redis/) | Redis 7 (RHEL9 image) with optional ServiceMonitor |
| [ipa-server](charts/ipa-server/) | FreeIPA server container with ingress and OpenShift-specific configuration |

All charts live under the **`charts/`** directory. Each chart includes:

- `Chart.yaml` – chart metadata  
- `values.yaml` – default values (annotated for [helm-docs](https://github.com/norwoodj/helm-docs) and [helm-schema](https://github.com/dadav/helm-schema))  
- `values.schema.json` – JSON schema for values (generated)  
- `README.md` – values reference (generated)  
- `templates/` – Kubernetes/OpenShift manifests  

## Prerequisites

- [Helm](https://helm.sh/) 3.x
- OpenShift or Kubernetes cluster (charts are tested with OpenShift)
- For building docs/schema: [Go](https://go.dev/) (optional; used to install tooling via the Makefile)

## Installing a chart

### From the Helm repository

Add the repo and install a chart:

```bash
helm repo add openshift-helm https://rgordill.github.io/openshift-helm-from-templates/
helm repo update

helm install my-postgresql openshift-helm/postgresql
helm install my-redis openshift-helm/redis
helm install my-ipa openshift-helm/ipa-server
```

**Helm repository URL:** [https://rgordill.github.io/openshift-helm-from-templates/](https://rgordill.github.io/openshift-helm-from-templates/)

### From a local clone

Alternatively, install from the repository root:

```bash
helm install my-postgresql ./charts/postgresql
helm install my-redis ./charts/redis
helm install my-ipa ./charts/ipa-server
```

### Override values

```bash
helm install my-postgresql openshift-helm/postgresql -f my-values.yaml
# or
helm install my-postgresql openshift-helm/postgresql --set postgresql.database=mydb
```

## Documentation and schema

Values are documented in each chart’s `values.yaml` using comments. The project uses:

- **helm-docs** – generates each chart’s `README.md` with a values table  
- **helm-schema** – generates `values.schema.json` for validation and IDE support  

### Using the Makefile

From the repository root:

| Target | Description |
|--------|-------------|
| `make` or `make all` | Install tools (if missing via `go install`), then generate schema and docs for all charts |
| `make install-tools` | Install helm-docs and helm-schema via Go if not on PATH |
| `make schema` | Generate `values.schema.json` for each chart in `charts/` |
| `make docs` | Generate `README.md` for each chart in `charts/` |
| `make help` | List targets and discovered charts |

Run `make docs` (and `make schema` if needed) before committing when you change `values.yaml` or `Chart.yaml` so chart READMEs and schemas stay in sync.

Tools are installed under `$(go env GOPATH)/bin` when not present. To use the npm-based schema generator instead:

```bash
make schema HELM_SCHEMA_GEN=npx
```

Charts are discovered under the `charts/` directory. To use another directory:

```bash
make CHARTS_DIR=my-charts
```

## Repository structure

```
.
├── charts/
│   ├── postgresql/
│   ├── redis/
│   └── ipa-server/
├── .github/
│   └── workflows/
│       └── release.yml    # Chart releaser (charts_dir: charts)
├── Makefile               # Docs/schema generation
├── README.md               # This file
└── LICENSE
```

## License

[Apache License 2.0](LICENSE).
