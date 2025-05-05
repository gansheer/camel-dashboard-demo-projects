#!/bin/bash

location=$(dirname $0)

echo 'Clean projects'
oc delete project camel-demo-1
oc delete project camel-demo-2
oc new-project camel-demo-1
oc new-project camel-demo-2
oc project default

podman login --tls-verify=false -u kubeadmin -p $(oc whoami -t) default-route-openshift-image-registry.apps-crc.testing
docker login -u kubeadmin -p $(oc whoami -t) default-route-openshift-image-registry.apps-crc.testing

echo 'Deploy camel-main'
oc project camel-demo-1
pushd $location/camel-main
./mvnw clean package oc:deploy
popd


echo 'Deploy camel-quarkus'
oc project camel-demo-2
pushd $location/camel-quarkus
./mvnw clean package oc:deploy
popd

echo 'Deploy camel-spring'
oc project camel-demo-2
pushd $location/camel-spring
./mvnw clean package oc:deploy
popd

echo 'Deploy camel-spring-jolokia'
oc project camel-demo-2
pushd $location/camel-spring-jolokia
./mvnw clean package oc:deploy
popd

echo 'Deploy camel-cronjob'
oc project camel-demo-2
pushd $location/camel-cronjob
./mvnw clean package -Dquarkus.openshift.deploy=true
popd

