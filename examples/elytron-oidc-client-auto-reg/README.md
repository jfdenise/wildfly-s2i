# Elytron OpenID Connect (OIDC) client with automatic registration example on Openshift

In this example we are provisioning a WildFly server and deploying an application secured 
with OIDC (OpenID Connect).

In this example, the OIDC configuration is automatically generated and Realm client added to the server.

# WildFly Maven plugin configuration
High level view of the WildFly Maven plugin configuration

## Galleon feature-packs

* `org.wildfly:wildfly-galleon-pack`
* `org.wildfly.cloud:wildfly-cloud-galleon-pack`

## Galleon layers

* `cloud-server`
* `elytron-oidc-client`

## CLI scripts
WildFly CLI scripts executed at packaging time

* None

## Extra content
Extra content packaged inside the provisioned server

* None

# Openshift build and deployment
Technologies required to build and deploy this example

* Helm chart for WildFly `wildfly/wildfly`. Minimal version `2.0.0`.

# WildFly image API
Environment variables from the [WildFly image API](https://github.com/wildfly/wildfly-cekit-modules/blob/main/jboss/container/wildfly/run/api/module.yaml) that must be set in the OpenShift deployment environment

* None

# WildFly cloud feature-pack API
Environment variables defined by the cloud feature-pack used to configure the server:

* `OIDC_PROVIDER_NAME`. Value `keycloak`, required
* `OIDC_USER_NAME`. User name to retrieve token used to create Clients.
* `OIDC_USER_PASSWORD`. User password to retrieve token used to create Client.
* `OIDC_SECURE_DEPLOYMENT_SECRET`. Secret known by the Client.
* `OIDC_PROVIDER_URL`. Keycloak server URL.
* `OIDC_HOSTNAME_HTTPS`. Web application host name.

# Pre-requisites

* You are logged into an OpenShift cluster and have `oc` command in your path

* You have installed Helm. Please refer to [Installing Helm page](https://helm.sh/docs/intro/install/) to install Helm in your environment

* You have installed the repository for the Helm charts for WildFly

 ```
helm repo add wildfly https://docs.wildfly.org/wildfly-charts/
```
----
**NOTE**

If you have already installed the Helm Charts for WildFly, make sure to update your repository to the latest version.

```
helm repo update
```
----

# Example steps

1. Deploy an SSO server. Use the Sandbox Developer Catalog, search for sso and instantiate RH SSO 7.5 template. You can keep the default values 
when instantiating the template.

To retrieve the SSO admin user name and password that will be needed to log into the SSO admin console, 
access the SSO deployment config and look for `SSO_ADMIN_USERNAME` and `SSO_ADMIN_PASSWORD` env variable values.

3. Create the SSO realm, user and role

  * Log into the SSO admin console (`https://<SSO route>/auth/`). You must use the values of `SSO_ADMIN_USERNAME` and `SSO_ADMIN_PASSWORD` to log-in. 
  * Create a Realm named `WildFly`
  * Create a Role named `Users`
  * Create a User named `demo`, password `demo`, make the password not temporary.
  * Assign the role `Users` to the user `demo`
  * Go to Roles, select `default-roles-wildfly`, in the `Client Roles` Select the Client `realm-management`, assign the role `create-client`

2. Deploy the example application using WildFly Helm charts

```
helm install elytron-oidc-client-app-auto-reg -f helm.yaml wildfly/wildfly
```

3. Finally add the env variable to the `elytron-oidc-client-app-auto-reg` deployment to convey the system property to the server

`oc set env deployment/elytron-oidc-client-app-auto-reg OIDC_HOSTNAME_HTTPS=<application route hostname>`
`oc set env deployment/elytron-oidc-client-app-auto-reg OIDC_PROVIDER_URL=https://<sso service route>/auth/realms/WildFly`

Then do an upgrade of the Helm charts to reflect your changes done to the deployment

`helm upgrade elytron-oidc-client-app-auto-reg wildfly/wildfly`

5. Access the application: `https://<elytron-oidc-client-app-auto-reg route>/simple-webapp`

6. Access the secured servlet.

7. Log-in using the `demo` user, `demo` password (that you created in the initial steps)

8. You should see a page containing the Principal ID

