#!/bin/bash

kube::util::sortable_date() {
  date "+%Y%m%d-%H%M%S"
}

kube::util::wait_for_url() {
  local url=$1
  local prefix=${2:-}
  local wait=${3:-1}
  local times=${4:-30}

  which curl >/dev/null || {
    kube::log::usage "curl must be installed"
    exit 1
  }

  local i
  for i in $(seq 1 $times); do
    local out
    if out=$(curl --max-time 1 -gkfs $url 2>/dev/null); then
      kube::log::status "On try ${i}, ${prefix}: ${out}"
      return 0
    fi
    sleep ${wait}
  done
  kube::log::error "Timed out waiting for ${prefix} to answer at ${url}; tried ${times} waiting ${wait} between each"
  return 1
}

# Opposite of kube::util::ensure-temp-dir()
kube::util::cleanup-temp-dir() {
  rm -rf "${KUBE_TEMP}"
}

# Create a temp dir that'll be deleted at the end of this bash session.
#
# Vars set:
#   KUBE_TEMP
kube::util::ensure-temp-dir() {
  if [[ -z ${KUBE_TEMP-} ]]; then
    KUBE_TEMP=$(mktemp -d 2>/dev/null || mktemp -d -t kubernetes.XXXXXX)
    kube::util::trap_add kube::util::cleanup-temp-dir EXIT
  fi
}

# This figures out the host platform without relying on golang.  We need this as
# we don't want a golang install to be a prerequisite to building yet we need
# this info to figure out where the final binaries are placed.
kube::util::host_platform() {
  local host_os
  local host_arch
  case "$(uname -s)" in
    Darwin)
      host_os=darwin
      ;;
    Linux)
      host_os=linux
      ;;
    *)
      kube::log::error "Unsupported host OS.  Must be Linux or Mac OS X."
      exit 1
      ;;
  esac

  case "$(uname -m)" in
    x86_64*)
      host_arch=amd64
      ;;
    i?86_64*)
      host_arch=amd64
      ;;
    amd64*)
      host_arch=amd64
      ;;
    aarch64*)
      host_arch=arm64
      ;;
    arm64*)
      host_arch=arm64
      ;;
    arm*)
      host_arch=arm
      ;;
    i?86*)
      host_arch=x86
      ;;
    s390x*)
      host_arch=s390x
      ;;
    ppc64le*)
      host_arch=ppc64le
      ;;
    *)
      kube::log::error "Unsupported host arch. Must be x86_64, 386, arm, arm64, s390x or ppc64le."
      exit 1
      ;;
  esac
  echo "${host_os}/${host_arch}"
}
