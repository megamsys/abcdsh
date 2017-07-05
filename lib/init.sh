#!/bin/bash

# Copyright <2017> <Megam Systems Authors>

# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
# associated documentation files (the "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all copies or
# substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
# BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
# AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

set -o errexit

# The root of the abcdsh directory
ABCD_ROOT="$(cd "$(dirname "${BASH_SOURCE}")/../" && pwd -P)"

ABCD_OUTPUT_SUBPATH="${ABCD_OUTPUT_SUBPATH:-_output/local}"
ABCD_OUTPUT="${ABCD_ROOT}/${ABCD_OUTPUT_SUBPATH}"
ABCD_OUTPUT_BINPATH="${ABCD_OUTPUT}/bin"

ONE_CLUSTER_OUT="${ABCD_OUTPUT}/cluster_out"
ONE_HOST_OUT="${ABCD_OUTPUT}/host_out"
ONE_NETWORK_OUT="${ABCD_OUTPUT}/network_out"
ONE_IMAGES_OUT="${ABCD_OUTPUT}/images_out"
ONE_DS_OUT="${ABCD_OUTPUT}/ds_out.sh"

source "${ABCD_ROOT}/lib/logging.sh"

#abcd::log::install_errexit
