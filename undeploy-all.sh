#!/bin/bash

location=$(dirname $0)


#podman login --tls-verify=false -u kubeadmin -p $(oc whoami -t) default-route-openshift-image-registry.apps-crc.testing
#docker login -u kubeadmin -p $(oc whoami -t) default-route-openshift-image-registry.apps-crc.testing

echo 'Undeploy camel-main'
oc project camel-demo-1
pushd $location/camel-main
./mvnw oc:undeploy
popd


echo 'Undeploy camel-quarkus'
oc project camel-demo-2
pushd $location/camel-quarkus
./mvnw oc:undeploy
kubectl delete -f target/kubernetes/openshift.yml
popd

echo 'Undeploy camel-spring'
oc project camel-demo-2
pushd $location/camel-spring
./mvnw oc:undeploy
popd

#echo 'Undeploy camel-cronjob'
#oc project camel-demo-2
#pushd $location/camel-cronjob
#kubectl delete -f target/kubernetes/openshift.yml
#popd

