#!/bin/bash

location=$(dirname $0)

echo 'Add camel-dashboard-operator CRD'
kubectl apply -k 'github.com/squakez/camel-dashboard-operator/pkg/resources/config/crd?ref=main'


echo 'Create camel-dashboard-operator CR'
./crs/generate_crs.py 'camel-spring' 'camel-demo-2' '4.11.0' 'Spring-Boot' '3.4.3'
kubectl apply -n camel-demo-2 -f $location/crs/camel-spring-camel-demo-2.yml
kubectl patch apps.camel.apache.org camel-spring -n camel-demo-2 --patch-file $location/crs/camel-spring-camel-demo-2.yml  --type=merge --subresource='status'

./crs/generate_crs.py 'camel-quarkus' 'camel-demo-2' '4.11.0' 'Quarkus' '3.20.0'
kubectl apply -n camel-demo-2 -f $location/crs/camel-quarkus-camel-demo-2.yml
kubectl patch apps.camel.apache.org camel-quarkus -n camel-demo-2 --patch-file $location/crs/camel-quarkus-camel-demo-2.yml  --type=merge --subresource='status'

./crs/generate_crs.py 'camel-main' 'camel-demo-1' '4.11.0' 'Main' '4.11.0'
kubectl apply -n camel-demo-1 -f $location/crs/camel-main-camel-demo-1.yml
kubectl patch apps.camel.apache.org camel-main -n camel-demo-1 --patch-file $location/crs/camel-main-camel-demo-1.yml  --type=merge --subresource='status'

