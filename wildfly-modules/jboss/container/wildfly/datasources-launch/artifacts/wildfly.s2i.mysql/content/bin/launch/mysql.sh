#!/bin/sh

function configure() {
 local configureMode=$(getConfigurationMode)
 if [ "${configureMode}" = "cli" ]; then
  configureByCli
 fi
}

function configureByCli() {
 if [ -n "$MYSQL_DATABASE" ]
 then
  cat <<'EOF' >> ${CLI_SCRIPT_FILE}
      if (outcome == success) of /subsystem=datasources/data-source=MySQLDS:read-resource
        /subsystem=datasources/data-source=MySQLDS:write-attribute(name=enabled,value=true)
      end-if
EOF
 fi
}