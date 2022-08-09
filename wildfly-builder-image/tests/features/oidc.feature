@wildfly/wildfly-s2i-jdk17
@wildfly/wildfly-s2i-jdk11
Feature: OIDC tests

   Scenario: Check oidc subsystem configuration.
     Given XML namespaces
       | prefix | url                          |
       | ns     | urn:wildfly:elytron-oidc-client:1.0 |
     Given s2i build http://github.com/jfdenise/wildfly-s2i from test/test-app-elytron-oidc-client with env and True using ee-10-migration
       | variable               | value                                            |
       | OIDC_PROVIDER_NAME | keycloak |
       | OIDC_PROVIDER_URL           | http://localhost:8080/auth/realms/demo    |
       | OIDC_SECURE_DEPLOYMENT_ENABLE_CORS        | true                          |
       | OIDC_SECURE_DEPLOYMENT_BEARER_ONLY        | true                          |
       | MAVEN_REPO_ID | opensaml |
       | MAVEN_REPO_NAME | opensaml |
       | MAVEN_REPO_URL | https://build.shibboleth.net/nexus/content/groups/public |
       ### PLACEHOLDER FOR CLOUD CUSTOM TESTING ###
    Then container log should contain WFLYSRV0010: Deployed "oidc-webapp.war"
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value keycloak on XPath //ns:provider/@name
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value oidc-webapp.war on XPath //*[local-name()='secure-deployment']/@name
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='provider']/*[local-name()='enable-cors']
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='secure-deployment'][@name="oidc-webapp.war"]/*[local-name()='bearer-only']
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='secure-deployment'][@name="oidc-webapp.war"]/*[local-name()='enable-basic-auth'] 
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value http://localhost:8080/auth/realms/demo on XPath //*[local-name()='provider']/*[local-name()='provider-url']

  Scenario: Provision oidc subsystem configuration, legacy.
     Given s2i build http://github.com/jfdenise/wildfly-s2i from test/test-app-elytron-oidc-client-legacy with env and True using ee-10-migration
       | variable               | value                                            |
       | GALLEON_PROVISION_LAYERS | cloud-server,elytron-oidc-client |
       | GALLEON_PROVISION_FEATURE_PACKS|org.wildfly:wildfly-galleon-pack:27.0.0.Alpha4,org.wildfly.cloud:wildfly-cloud-galleon-pack:2.0.0.Alpha4 |
       | MAVEN_REPO_ID | opensaml |
       | MAVEN_REPO_NAME | opensaml |
       | MAVEN_REPO_URL | https://build.shibboleth.net/nexus/content/groups/public |
  Scenario: Check oidc subsystem configuration, legacy.
     Given XML namespaces
       | prefix | url                          |
       | ns     | urn:wildfly:elytron-oidc-client:1.0 |
     When container integ- is started with env
       | variable               | value                                            |
       | OIDC_PROVIDER_NAME | keycloak |
       | OIDC_PROVIDER_URL           | http://localhost:8080/auth/realms/demo    |
       | OIDC_SECURE_DEPLOYMENT_ENABLE_CORS        | true                          |
       | OIDC_SECURE_DEPLOYMENT_BEARER_ONLY        | true                          |
    Then container log should contain WFLYSRV0010: Deployed "oidc-webapp-legacy.war"
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value keycloak on XPath //ns:provider/@name
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value oidc-webapp-legacy.war on XPath //*[local-name()='secure-deployment']/@name
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='provider']/*[local-name()='enable-cors']
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='secure-deployment'][@name="oidc-webapp-legacy.war"]/*[local-name()='bearer-only']
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='secure-deployment'][@name="oidc-webapp-legacy.war"]/*[local-name()='enable-basic-auth'] 
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value http://localhost:8080/auth/realms/demo on XPath //*[local-name()='provider']/*[local-name()='provider-url']

  Scenario: Check oidc subsystem configuration, legacy with ENV_FILES
     Given XML namespaces
       | prefix | url                          |
       | ns     | urn:wildfly:elytron-oidc-client:1.0 |
    When container integ- is started with command bash
       | variable                 | value           |
       | ENV_FILES | /tmp/oidc.env |
    Then copy features/image/scripts/oidc.env to /tmp in container
    And run sh -c '/opt/jboss/container/wildfly/run/run  > /tmp/boot.log 2>&1' in container and detach
    And file /tmp/boot.log should contain WFLYSRV0025
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value keycloak on XPath //ns:provider/@name
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value oidc-webapp-legacy.war on XPath //*[local-name()='secure-deployment']/@name
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='provider']/*[local-name()='enable-cors']
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='secure-deployment'][@name="oidc-webapp-legacy.war"]/*[local-name()='bearer-only']
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='secure-deployment'][@name="oidc-webapp-legacy.war"]/*[local-name()='enable-basic-auth'] 
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value http://localhost:8080/auth/realms/demo on XPath //*[local-name()='provider']/*[local-name()='provider-url']