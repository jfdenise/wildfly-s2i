How to check SAML Security locally with Podman on Mac

1. add in /etc/hosts
127.0.0.1	localhost host.containers.internal

2. Download and start keycloak
./keycloak/keycloak-26.6.4/bin/kc.sh start-dev --http-port 8777 --http-host 0.0.0.0
Read this doc to add realm,users,roles
https://docs.redhat.com/fr/documentation/red_hat_jboss_enterprise_application_platform/8.1/html-single/using_jboss_eap_on_openshift_container_platform/index#securing-applications-with-saml_assembly_building-and-running-jboss-eap-applicationson-openshift-container-platform

3. Start container (tested with JDK25 UBI10 image)
podman run --user root -p 8080:8080 -it --rm  ec45f2099c8a bash

4. Copy content to the container
in the wildfly-s2i/test directory
keytool -genkeypair -alias saml-app -storetype PKCS12 -keyalg RSA -keysize 2048 -keystore keystore.p12 -storepass password -dname "CN=saml-basic-auth,OU=EAP SAML Client,O=Red Hat EAP QE,L=MB,S=Milan,C=IT" -ext ku:c=dig,keyEncipherment -validity 365
keytool -importkeystore -deststorepass password -destkeystore keystore.jks -srckeystore keystore.p12 -srcstoretype PKCS12 -srcstorepass password

podman container ls
podman cp keystore.jks f2267fb7c376:/home/jboss
podman cp test-app-keycloak-saml f2267fb7c376:/home/jboss

5. Assemble the server, in the running container 
export SSO_REALM="saml-basic-auth" \
export  SSO_USERNAME="client-admin" \
export SSO_PASSWORD="client-admin" \
export  SSO_SAML_CERTIFICATE_NAME="saml-app" \
export SSO_SAML_KEYSTORE="keystore.jks" \
export SSO_SAML_KEYSTORE_PASSWORD="password" \
export SSO_SAML_KEYSTORE_DIR="/etc/sso-saml-secret-volume" \
export SSO_SAML_LOGOUT_PAGE="/saml-app" \
export SSO_DISABLE_SSL_CERTIFICATE_VALIDATION="true" \
export SSO_URL="http://host.containers.internal:8777" \
export HOSTNAME_HTTP="localhost:8080"
mkdir -p /tmp/src
mkdir -p /etc/sso-saml-secret-volume
cp -r test-app-keycloak-saml/* /tmp/src/
cp keystore.jks /etc/sso-saml-secret-volume/
/usr/local/s2i/assemble 

6. Start the server
/usr/local/s2i/run

7. Access the web page: http://localhost:8080/saml-app/

