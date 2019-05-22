# wildfly-s2i

Requirements
============

Install [Cekit](https://cekit.io) by following the [https://cekit.readthedocs.io/en/latest/handbook/installation/instructions.html](instructions).

Build both images and run tests
===============================

```
$ make test
```
==> Image `wildfly/wildfly-170-centos7` and `wildfly/wildfly-runtime-170-centos7` created

Build builder image
===================

```
$ cd wildfly-builder-image
$ cekit build docker
```
==> Image `wildfly/wildfly-170-centos7` created

Build runtime image
===================

```
$ cd wildfly-runtime-image
$ cekit build docker
````

==> Image `wildfly/wildfly-runtime-170-centos7` created

