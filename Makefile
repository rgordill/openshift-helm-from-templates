# Makefile for generating Helm chart schema and values documentation
#
# Prerequisites: Go toolchain (for automatic install), or install manually:
#   - helm-docs: https://github.com/norwoodj/helm-docs
#     e.g. go install github.com/norwoodj/helm-docs/cmd/helm-docs@latest
#   - helm-schema: Helm plugin or Go binary
#     Plugin: helm plugin install https://github.com/holgerjh/helm-schema
#     Go binary: go install github.com/dadav/helm-schema/cmd/helm-schema@latest
#     Or npm: make schema HELM_SCHEMA_GEN=npx
#

SHELL := /bin/bash
# Ensure Go-installed tools are on PATH
export PATH := $(shell go env GOPATH 2>/dev/null || echo $(HOME)/go)/bin:$(PATH)

HELM_SCHEMA_GEN ?= helm
# Set HELM_SCHEMA_GEN=npx to use: npx @socialgouv/helm-schema -f values.yaml

# Chart search root and discovered chart directories
CHARTS_DIR ?= charts
CHARTS := $(patsubst %/Chart.yaml,%,$(shell find $(CHARTS_DIR) -name 'Chart.yaml' -not -path '*/.git/*' | sort))

.PHONY: all schema docs help install-tools check-tools

all: install-tools schema docs
	@echo "Done: schema and docs generated for charts: $(CHARTS)"

# Install helm-docs and helm-schema via go install if not available (requires Go)
install-tools:
	@command -v go >/dev/null 2>&1 || (echo "Error: Go is required for automatic install. Install tools manually or add Go to PATH."; exit 1)
	@command -v helm-docs >/dev/null 2>&1 || (echo "Installing helm-docs..."; go install github.com/norwoodj/helm-docs/cmd/helm-docs@latest)
	@if [ "$(HELM_SCHEMA_GEN)" = "npx" ]; then \
		true; \
	elif helm schema create --help >/dev/null 2>&1; then \
		true; \
	elif command -v helm-schema >/dev/null 2>&1; then \
		true; \
	else \
		echo "Installing helm-schema (Go binary)..."; \
		go install github.com/dadav/helm-schema/cmd/helm-schema@latest; \
	fi

# Generate values.schema.json for each chart
schema: install-tools
	@if [ "$(HELM_SCHEMA_GEN)" = "npx" ]; then \
		for chart in $(CHARTS); do \
			echo "Generating schema for $$chart..."; \
			npx --yes @socialgouv/helm-schema -f "$$chart/values.yaml" > "$$chart/values.schema.json" || exit 1; \
		done; \
	elif command -v helm-schema >/dev/null 2>&1 && ! helm schema create --help >/dev/null 2>&1; then \
		echo "Generating schema with helm-schema (Go binary)..."; \
		helm-schema --chart-search-root=$(CHARTS_DIR) --helm-docs-compatibility-mode || exit 1; \
	else \
		for chart in $(CHARTS); do \
			echo "Generating schema for $$chart..."; \
			(cd "$$chart" && helm schema create values.yaml -o values.schema.json) || exit 1; \
		done; \
	fi
	@echo "Schema generation complete."

# Generate README.md (values table) for all charts using helm-docs
docs: install-tools
	@helm-docs --chart-search-root=$(CHARTS_DIR)
	@echo "Documentation generation complete."

help:
	@echo "Targets:"
	@echo "  all           - Generate schema and docs for all charts (default)"
	@echo "  install-tools - Install helm-docs and helm-schema via go install if missing"
	@echo "  schema        - Generate values.schema.json for each chart (helm-schema)"
	@echo "  docs          - Generate README.md with values table for each chart (helm-docs)"
	@echo "  help          - Show this help"
	@echo ""
	@echo "Charts directory: $(CHARTS_DIR)"
	@echo "Charts found: $(CHARTS)"
	@echo ""
	@echo "Schema generator: HELM_SCHEMA_GEN=$(HELM_SCHEMA_GEN)"
	@echo "  Use 'make schema HELM_SCHEMA_GEN=npx' to use @socialgouv/helm-schema"

check-tools: install-tools
	@command -v helm-docs >/dev/null 2>&1 || (echo "Error: helm-docs not found. Run: go install github.com/norwoodj/helm-docs/cmd/helm-docs@latest"; exit 1)
	@if [ "$(HELM_SCHEMA_GEN)" = "npx" ]; then \
		true; \
	elif command -v helm-schema >/dev/null 2>&1 || helm schema create --help >/dev/null 2>&1; then \
		true; \
	else \
		echo "Error: helm-schema not found. Run: go install github.com/dadav/helm-schema/cmd/helm-schema@latest"; exit 1; \
	fi
