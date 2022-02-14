SHELL := /bin/bash
$(VERBOSE).SILENT:
.DEFAULT_GOAL := help

.PHONY: help
help:
	echo 'run "make build" to build the execution environment'

.PHONY: build
build: build-ee-builder build-ee-base ansible-builder image-prune

.PHONY: build-ee-builder
build-ee-builder:
	./tools/build_ee_builder_image.sh

.PHONY: build-ee-base
build-ee-base:
	./tools/build_ee_base_image.sh

.PHONY: ansible-builder
ansible-builder:
	ansible-builder build -v3 -c . -t quay.io/jakemalley/awx-ee:latest --container-runtime podman

.PHONY: image-prune
image-prune:
	podman image prune --force

.PHONY: test
test:
	ansible-runner run --process-isolation --process-isolation-executable podman --container-image quay.io/jakemalley/awx-ee:latest -p test.yml test/

.PHONY: publish
publish:
	podman push quay.io/jakemalley/awx-ee:latest

.PHONY: clean
clean:
	podman image prune --force
	podman container prune --force
	podman rm --force `podman ps -q` || true
	podman rmi --force `podman images -q` || true

