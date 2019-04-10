#  Copyright (c) 2019 WSO2 Inc. (http:www.wso2.org) All Rights Reserved.
#
#  WSO2 Inc. licenses this file to you under the Apache License,
#  Version 2.0 (the "License"); you may not use this file except
#  in compliance with the License.
#  You may obtain a copy of the License at
#
#  http:www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing,
#  software distributed under the License is distributed on an
#  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
#  KIND, either express or implied.  See the License for the
#  specific language governing permissions and limitations
#  under the License.

PROJECT_ROOT := $(realpath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
DOCKER_REPO ?= wso2cellery
DOCKER_IMAGE_TAG ?= latest
CELLERY_ORG ?= wso2cellery
CELLERY_VERSION ?= 0.1.0

SAMPLES := pet-store hello-world-web hello-world-api

CLEAN_TARGETS := $(addprefix clean., $(SAMPLES))
CHECK_STYLE_TARGETS := $(addprefix check-style., $(SAMPLES))
BUILD_TARGETS := $(addprefix build., $(SAMPLES))
DOCKER_TARGETS := $(addprefix docker., $(SAMPLES))
DOCKER_PUSH_TARGETS := $(addprefix docker-push., $(SAMPLES))
CELLERY_BUILD_TARGETS := $(addprefix cellery-build., $(SAMPLES))


all: clean build docker

.PHONY: clean
clean: $(CLEAN_TARGETS)

.PHONY: check-style
check-style: $(CHECK_STYLE_TARGETS)

.PHONY: build
build: $(BUILD_TARGETS)

.PHONY: docker
docker: $(DOCKER_TARGETS)

.PHONY: docker-push
docker-push: $(DOCKER_PUSH_TARGETS)

.PHONY: cellery-build
cellery-build: $(CELLERY_BUILD_TARGETS)


## Sample Level Targets

.PHONY: $(CLEAN_TARGETS)
$(CLEAN_TARGETS):
	$(eval SAMPLE=$(patsubst clean.%,%,$@))
	@cd $(SAMPLE); \
	$(MAKE) clean

.PHONY: $(CHECK_STYLE_TARGETS)
$(CHECK_STYLE_TARGETS):
	$(eval SAMPLE=$(patsubst check-style.%,%,$@))
	@cd $(SAMPLE); \
	$(MAKE) check-style

.PHONY: $(BUILD_TARGETS)
$(BUILD_TARGETS):
	$(eval SAMPLE=$(patsubst build.%,%,$@))
	@cd $(SAMPLE); \
	$(MAKE) build

.PHONY: $(DOCKER_TARGETS)
$(DOCKER_TARGETS):
	$(eval SAMPLE=$(patsubst docker.%,%,$@))
	@cd $(SAMPLE); \
	$(MAKE) docker

.PHONY: $(DOCKER_PUSH_TARGETS)
$(DOCKER_PUSH_TARGETS):
	$(eval SAMPLE=$(patsubst docker-push.%,%,$@))
	@cd $(SAMPLE); \
	$(MAKE) docker-push

.PHONY: $(CELLERY_BUILD_TARGETS)
$(CELLERY_BUILD_TARGETS):
	$(eval SAMPLE=$(patsubst cellery-build.%,%,$@))
	@cd $(SAMPLE); \
	$(MAKE) cellery-build
