#!/bin/sh
# Configure module
set -e
# Create link to JBOSS_HOME. Legacy wildfly location.
ln -s $JBOSS_HOME /wildfly

# link deployments
cp -r $JBOSS_HOME/standalone/deployments/* /deployments
rm -rf $JBOSS_HOME/standalone/deployments
ln -s /deployments $JBOSS_HOME/standalone/deployments

# cleanup maven artifacts
rm -rf $GALLEON_LOCAL_MAVEN_REPO/org/codehaus/plexus/plexus

chown -R jboss:root $HOME