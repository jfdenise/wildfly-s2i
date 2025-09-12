#!/bin/sh
# Configure module
set -e

SCRIPT_DIR=$(dirname $0)
ARTIFACTS_DIR=${SCRIPT_DIR}/artifacts

install -m 0664 -D {${ARTIFACTS_DIR},}/opt/jboss/container/maven/default/jboss-settings.xml
