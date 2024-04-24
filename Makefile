SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help

.PHONY: help deploy serve lint fmt
export
PWD=$(shell pwd)
PREFECT_HOME=$(PWD)
PREFECT_LOCAL_STORAGE_PATH=$(PREFECT_HOME)/storage
PREFECT_API_DATABASE_CONNECTION_URL=sqlite+aiosqlite:///$(PREFECT_HOME)/prefect.db
PREFECT_API_URL=http://127.0.0.1:4200/api
PREFECT_EXPERIMENTAL_ENABLE_EXTRA_RUNNER_ENDPOINTS=True
PREFECT_RUNNER_SERVER_HOST=127.0.0.1

deploy: ## Deploy the flow
	@poetry run python ./prefect-parallel-process/main.py

serve: ## Start the server
	@echo $(PREFECT_HOME)
	@echo $(PREFECT_LOCAL_STORAGE_PATH)
	@poetry run prefect server start

help: ## Show this help message
	@echo "Usage: make [target]"
	@echo ""
	@echo "Available targets:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(filter-out .env,$(MAKEFILE_LIST)) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
