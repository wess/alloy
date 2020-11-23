#
# Makefile
# Ancilla
# 
# Author: Wess (wess@frenzylabs.com)
# Created: 11/19/2020
# 
# Copywrite (c) 2020 FrenzyLabs, LLC.
#

ROOT_DIR 	   := $(abspath $(lastword $(MAKEFILE_LIST)))
PROJECT_DIR	 := $(notdir $(patsubst %/,%,$(dir $(ROOT_DIR))))
PROJECT 		 := $(lastword $(PROJECT_DIR))
VERSION_FILE 	= VERSION
VERSION			 	= `cat $(VERSION_FILE)`
SRC_VOLUME 		= "${PWD}/${PROJECT}"

default: run

.PHONY: help
help: ## Print all the available commands
	@echo "" \
	&& echo "Alloy ${VERSION}" \
	&& echo "" \
	&& grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	  awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' \
	&& echo ""
	
build: ## Build the Alloy environment
	@echo \
	&& echo "Building Alloy environment..." \
	&& docker build --rm --tag alloy:${VERSION} .

run: build ## Run Alloy live environment
	@echo \
	&& echo "Connecting to Alloy environment" \
	&& docker run -it --privileged=true --network=host --rm -v "${SRC_VOLUME}":/alloy alloy:${VERSION}

release:  ## Build the project in release mode
	@echo "Release"

setup:  ## Setup for development
	@echo "Setup Env"

