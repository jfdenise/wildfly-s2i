@wildfly/wildfly-s2i
Feature: Wildfly stability related tests

  Scenario: Check that the server starts properly at the preview stability level
   Given s2i build https://github.com/jfdenise/wildfly-s2i from test/test-app-stability-preview with env and True using test-ubi10
   | variable    |        value        |
   | SERVER_ARGS | --stability=preview |
   ### PLACEHOLDER FOR CLOUD CUSTOM TESTING ###
   Then container log should contain WFLYSRV0025
