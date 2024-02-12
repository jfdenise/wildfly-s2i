# EJB, JSF and JPA example.

In this example we are provisioning a WildFly server and deploying a JSF application.

# WildFly Maven plugin configuration
High level view of the WildFly Maven plugin configuration

## Galleon feature-packs

* `org.wildfly:wildfly-galleon-pack`

## Galleon layers discovered by WildFly Glow

* `ee-core-profile-server`
* `ejb-lite`
* `jsf`
* `jpa`
* `h2-driver`

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
----
**NOTE**

Be sure you have created OpenShift project. In some clusters it is created by default, whereas in others you have to create it manually.

Check what project is currently active:

```
oc project -q
```

If above command returns with error stating no project has been set, create a project using following command:

```
oc new-project myproject
```
----

# Example steps

1. Deploy the example application using WildFly Helm charts

```
helm install jsf-ejb-jpa-app -f helm.yaml wildfly/wildfly
```

2. You can then access the application: `https://<jsf-ejb-jpa-app route>/`. You will see pre-populated tasks. You can add / delete tasks. 
