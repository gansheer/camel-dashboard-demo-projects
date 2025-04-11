#!/usr/bin/env python3
import subprocess
import json
import yaml
import sys

cr = {
    "apiVersion": "camel.apache.org/v1alpha1",
    "kind": "App",
    "metadata":{
          "annotations": {
            "camel.apache.org/imported-from-kind": "Deployment",
            "camel.apache.org/is-synthetic": "true",
          },
        "ownerReferences":[
            {
                "apiVersion": "apps/v1",
                "controller": True,
                "kind": "Deployment"
            }
        ]
    },
    "spec": {},
    "status":{
        "phase": "Running",
        "pods": [],
    }
}


def generate_deployment_cmd(name, namespace):
    return ['kubectl', 
        'get', 
        'deployment', 
        name, 
        '-n',
        namespace,
        '--output=jsonpath={.metadata.name}|{@.metadata.uid}']


def generate_pods_cmd(name, namespace):
    return ['kubectl', 
        'get', 
        'pod', 
        '-l', 
        'app='+name, 
        '-n',
        namespace,
        '--output=jsonpath={range .items[*]}{@.metadata.name}|{@.metadata.uid}|{@.spec.containers[0].image}|{@.status.podIP};{end}']

def run_command(command):
    p = subprocess.Popen(command,
                         stdout=subprocess.PIPE,
                         stderr=subprocess.STDOUT)
    return iter(p.stdout.readline, b'')

def fill_cr_deployment(cr, deployment):
    cr["metadata"]["ownerReferences"][0]={
                "apiVersion": "apps/v1",
                "controller": True,
                "kind": "Deployment",
                "name": deployment.split('|')[0],
                "uid": deployment.split('|')[1],
            }
    cr["metadata"]["annotations"]["camel.apache.org/imported-from-name"]=deployment.split('|')[0]

def fill_cr_pods(cr, pods, camel_version, runtime_provider, runtime_version):
    for pod in pods.strip(';').split(';'):
        cr["status"]["image"]= pod.split('|')[2]
        podItem = { 
            "internalIp": pod.split('|')[3],
            "name": pod.split('|')[0],
            "observe": {
                "healthEndpoint": "observe/health",
                "healthPort": 8080,
                "metricsEndpoint": "observe/metrics",
                "metricsPort": 8080,
            },
            "ready": True,
            "runtime": {
                "camelVersion": camel_version,
                "exchange": {
                    "succeed": 111,
                    "total": 111,
                },
                "runtimeProvider": runtime_provider,
                "runtimeVersion": runtime_version, 
                "status": "UP",
            },
            "status": "Running"
        }
        cr["status"]["pods"].append(podItem)
        
    cr["status"]["replicas"] = len(cr["status"]["pods"])


def generate_cr(name, namespace, camel_version, runtime_provider, runtime_version):
    print('Parameters '+name+' '+namespace+' '+camel_version+' '+runtime_provider+' '+runtime_version)
    cr["metadata"]["name"] = name
    cr["metadata"]["namespace"] = namespace
    print(cr)
    deploymentLine = next(run_command(generate_deployment_cmd(name,namespace)))
    print(deploymentLine)
    fill_cr_deployment(cr, deploymentLine.decode("utf-8"))
    podsLine = next(run_command(generate_pods_cmd(name,namespace)))
    print(podsLine)
    fill_cr_pods(cr, podsLine.decode("utf-8"), camel_version, runtime_provider, runtime_version)
    


# Run with:
# 'camel-spring' 'camel-demo-2' '4.11.0' 'Spring-Boot' '3.4.3'

print(sys.argv)
generate_cr(sys.argv[1],sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5])

#print(json.dumps(cr, indent=4))
#print(yaml.dump(cr, indent=2))

with open('./crs/'+sys.argv[1]+'-'+sys.argv[2]+'.yml', 'w') as outfile:
    yaml.dump(cr, outfile, default_flow_style=False, indent=2)