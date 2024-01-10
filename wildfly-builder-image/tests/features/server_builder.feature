@wildfly/wildfly-s2i
Feature: Wildfly server builder tests

  Scenario: Generate a server builder. Check that env variable is set during the build
   Given s2i build http://github.com/jfdenise/wildfly-s2i from test/test-app with env and True using wf-glow-test-apps
   | variable                 | value           |
   | WILDFLY_S2I_GENERATE_SERVER_BUILDER | true |
   | MAVEN_ARGS_APPEND_WILDFLY_SERVER_BUILDER | -Dfoo=bar -Dfoo2=bar2 |
   ### PLACEHOLDER FOR CLOUD CUSTOM TESTING ###
   Then s2i build log should contain Disabling incremental build, local maven cache will be deleted.
   Then s2i build log should contain MAVEN_ARGS_APPEND=-Dfoo=bar -Dfoo2=bar2
   Then container log should contain Running wildfly/wildfly-s2i
   Then container log should contain WFLYSRV0025

  Scenario: Generate a server builder. Check that maven cache is not deleted
   Given s2i build http://github.com/jfdenise/wildfly-s2i from test/test-app with env and True using wf-glow-test-apps
   | variable                 | value           |
   | WILDFLY_S2I_GENERATE_SERVER_BUILDER | true |
   | S2I_ENABLE_INCREMENTAL_BUILDS_WILDFLY_SERVER_BUILDER | true |
   ### PLACEHOLDER FOR CLOUD CUSTOM TESTING ###
   Then s2i build log should not contain Disabling incremental build, local maven cache will be deleted.
   Then container log should contain Running wildfly/wildfly-s2i
   Then container log should contain WFLYSRV0025

  Scenario: Emulate second level of build operated from generated builder
    When container integ- is started with command bash
       | variable                   | value       |
    Then run sh -c 'mkdir /tmp/src' in container and detach
    Then run sh -c 'touch /tmp/src/foo.war' in container and detach
    Then run sh -c '/usr/local/s2i/assemble  > /tmp/assemble.log 2>&1' in container and detach
    Then file /tmp/assemble.log should contain Builder image already contains a server, will only build and deploy applications.
    Then file /tmp/assemble.log should contain Copying extra deployments found in /deployments to /opt/server/standalone/deployments