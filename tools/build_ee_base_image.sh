#!/usr/bin/env bash
# build the custom ee base image for `ansible-builder`

set -eux

readonly EE_BASE_IMAGE_BASE=quay.io/ansible/ansible-runner:stable-2.12-devel
readonly EE_BASE_IMAGE=quay.io/jakemalley/awx-ee:ansible-runner_stable-2.12-devel

ee_base=$(buildah from "${EE_BASE_IMAGE_BASE}")

buildah run $ee_base -- bash -c " \
    dnf -y update && \
    dnf config-manager --set-enabled epel && \
    dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
"

buildah commit $ee_base "${EE_BASE_IMAGE}"
buildah rm $ee_base
