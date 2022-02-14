#!/usr/bin/env bash
# build the custom ee builder image for `ansible-builder`

set -eux

readonly EE_BUILDER_IMAGE_BASE=quay.io/ansible/ansible-builder:latest
readonly EE_BUILDER_IMAGE=quay.io/jakemalley/awx-ee:ansible-builder_latest

ee_builder=$(buildah from "${EE_BUILDER_IMAGE_BASE}")

buildah run $ee_builder -- bash -c " \
    dnf -y update && \
    dnf config-manager --set-enabled epel && \
    dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
"

buildah commit $ee_builder "${EE_BUILDER_IMAGE}"
buildah rm $ee_builder
