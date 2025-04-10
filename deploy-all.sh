#!/bin/bash

location=$(dirname $0)

echo 'Clean projects'
oc delete project camel-demo-1
oc delete project camel-demo-2
oc project default

podman login --tls-verify=false -u kubeadmin -p $(oc whoami -t) default-route-openshift-image-registry.apps-crc.testing
docker login -u kubeadmin -p $(oc whoami -t) default-route-openshift-image-registry.apps-crc.testing

echo 'Deploy camel-main'
oc new-project camel-demo-1
oc project camel-demo-1
pushd $location/camel-main
./mvnw clean package oc:deploy
popd


echo 'Deploy camel-quarkus'
oc new-project camel-demo-2
oc project camel-demo-2
pushd $location/camel-quarkus
./mvnw clean package oc:deploy
popd

echo 'Deploy camel-spring'
pushd $location/camel-spring
./mvnw clean package oc:deploy
popd

echo 'Deploy camel-cronjob'
pushd $location/camel-cronjob
./mvnw clean package -Dquarkus.openshift.deploy=true
popd