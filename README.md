# Demo projects

Login to docker/podman
```sh
podman login --tls-verify=false -u kubeadmin -p $(oc whoami -t) default-route-openshift-image-registry.apps-crc.testing
docker login -u kubeadmin -p $(oc whoami -t) default-route-openshift-image-registry.apps-crc.testing
```

## camel-cronjob deploy

```sh
./mvnw package -Dquarkus.openshift.deploy=true
```

## camel-main deploy

```sh
./mvnw clean package oc:deploy
```

## camel-quarkus deploy

```sh
./mvnw clean package oc:deploy
```

## camel-spring deploy

```sh
./mvnw clean package oc:deploy
```

## Troubleshoot

This camel-main can't be deployed in the same Openshift project as the other (at least quarkus ones). This results in failure of the other projects:

```
Starting the Java application using /opt/jboss/container/java/run/run-java.sh ...
INFO exec -a "java" java -XX:MaxRAMPercentage=80.0 -XX:+UseParallelGC -XX:MinHeapFreeRatio=10 -XX:MaxHeapFreeRatio=20 -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -XX:+ExitOnOutOfMemoryError -cp "." -jar /deployments/quarkus-run.jar 
INFO running in /deployments
__  ____  __  _____   ___  __ ____  ______ 
 --/ __ \/ / / / _ | / _ \/ //_/ / / / __/ 
 -/ /_/ / /_/ / __ |/ , _/ ,< / /_/ /\ \   
--\___\_\____/_/ |_/_/|_/_/|_|\____/___/   
2025-04-10 14:16:25,658 INFO  [org.apa.cam.qua.cor.CamelBootstrapRecorder] (main) Apache Camel Quarkus 3.20.0 is starting
2025-04-10 14:16:25,660 INFO  [org.apa.cam.mai.MainSupport] (main) Apache Camel (Main) 4.10.2 is starting
2025-04-10 14:16:25,688 ERROR [org.apa.cam.qua.mai.CamelMainRuntime] (main) Failed to start application: org.apache.camel.PropertyBindingException: Error binding property (camel.main.port=tcp://10.217.5.161:80) with name: port on bean: org.apache.camel.main.MainConfigurationProperties@34f392be with value: tcp://10.217.5.161:80
	at org.apache.camel.main.MainHelper.setPropertiesOnTarget(MainHelper.java:380)
	at org.apache.camel.main.BaseMainSupport.autoConfigurationMainConfiguration(BaseMainSupport.java:2300)
	at org.apache.camel.main.BaseMainSupport.autoconfigure(BaseMainSupport.java:565)
	at org.apache.camel.main.MainSupport.autoconfigure(MainSupport.java:79)
	at org.apache.camel.main.BaseMainSupport.postProcessCamelContext(BaseMainSupport.java:918)
	at org.apache.camel.quarkus.main.CamelMain.initCamelContext(CamelMain.java:112)
	at org.apache.camel.quarkus.main.CamelMain.doInit(CamelMain.java:82)
	at org.apache.camel.support.service.BaseService.init(BaseService.java:85)
	at org.apache.camel.quarkus.main.CamelMain.startEngine(CamelMain.java:133)
	at org.apache.camel.quarkus.main.CamelMainRuntime.start(CamelMainRuntime.java:49)
	at org.apache.camel.quarkus.core.CamelBootstrapRecorder.start(CamelBootstrapRecorder.java:47)
	at io.quarkus.runner.recorded.CamelBootstrapProcessor$boot548544167.deploy_0(Unknown Source)
	at io.quarkus.runner.recorded.CamelBootstrapProcessor$boot548544167.deploy(Unknown Source)
	at io.quarkus.runner.ApplicationImpl.doStart(Unknown Source)
	at io.quarkus.runtime.Application.start(Application.java:101)
	at io.quarkus.runtime.ApplicationLifecycleManager.run(ApplicationLifecycleManager.java:121)
	at io.quarkus.runtime.Quarkus.run(Quarkus.java:77)
	at io.quarkus.runtime.Quarkus.run(Quarkus.java:48)
	at io.quarkus.runtime.Quarkus.run(Quarkus.java:137)
	at io.quarkus.runner.GeneratedMain.main(Unknown Source)
	at io.quarkus.bootstrap.runner.QuarkusEntryPoint.doRun(QuarkusEntryPoint.java:68)
	at io.quarkus.bootstrap.runner.QuarkusEntryPoint.main(QuarkusEntryPoint.java:36)

2025-04-10 14:16:25,710 ERROR [io.qua.run.Application] (main) Failed to start application: java.lang.RuntimeException: Failed to start quarkus
	at io.quarkus.runner.ApplicationImpl.doStart(Unknown Source)
	at io.quarkus.runtime.Application.start(Application.java:101)
	at io.quarkus.runtime.ApplicationLifecycleManager.run(ApplicationLifecycleManager.java:121)
	at io.quarkus.runtime.Quarkus.run(Quarkus.java:77)
	at io.quarkus.runtime.Quarkus.run(Quarkus.java:48)
	at io.quarkus.runtime.Quarkus.run(Quarkus.java:137)
	at io.quarkus.runner.GeneratedMain.main(Unknown Source)
	at io.quarkus.bootstrap.runner.QuarkusEntryPoint.doRun(QuarkusEntryPoint.java:68)
	at io.quarkus.bootstrap.runner.QuarkusEntryPoint.main(QuarkusEntryPoint.java:36)
Caused by: java.lang.RuntimeException: java.lang.RuntimeException: org.apache.camel.PropertyBindingException: Error binding property (camel.main.port=tcp://10.217.5.161:80) with name: port on bean: org.apache.camel.main.MainConfigurationProperties@34f392be with value: tcp://10.217.5.161:80
	at org.apache.camel.quarkus.core.CamelBootstrapRecorder.start(CamelBootstrapRecorder.java:49)
	at io.quarkus.runner.recorded.CamelBootstrapProcessor$boot548544167.deploy_0(Unknown Source)
	at io.quarkus.runner.recorded.CamelBootstrapProcessor$boot548544167.deploy(Unknown Source)
	... 9 more
Caused by: java.lang.RuntimeException: org.apache.camel.PropertyBindingException: Error binding property (camel.main.port=tcp://10.217.5.161:80) with name: port on bean: org.apache.camel.main.MainConfigurationProperties@34f392be with value: tcp://10.217.5.161:80
	at org.apache.camel.quarkus.main.CamelMainRuntime.start(CamelMainRuntime.java:65)
	at org.apache.camel.quarkus.core.CamelBootstrapRecorder.start(CamelBootstrapRecorder.java:47)
	... 11 more
Caused by: org.apache.camel.PropertyBindingException: Error binding property (camel.main.port=tcp://10.217.5.161:80) with name: port on bean: org.apache.camel.main.MainConfigurationProperties@34f392be with value: tcp://10.217.5.161:80
	at org.apache.camel.main.MainHelper.setPropertiesOnTarget(MainHelper.java:380)
	at org.apache.camel.main.BaseMainSupport.autoConfigurationMainConfiguration(BaseMainSupport.java:2300)
	at org.apache.camel.main.BaseMainSupport.autoconfigure(BaseMainSupport.java:565)
	at org.apache.camel.main.MainSupport.autoconfigure(MainSupport.java:79)
	at org.apache.camel.main.BaseMainSupport.postProcessCamelContext(BaseMainSupport.java:918)
	at org.apache.camel.quarkus.main.CamelMain.initCamelContext(CamelMain.java:112)
	at org.apache.camel.quarkus.main.CamelMain.doInit(CamelMain.java:82)
	at org.apache.camel.support.service.BaseService.init(BaseService.java:85)
	at org.apache.camel.quarkus.main.CamelMain.startEngine(CamelMain.java:133)
	at org.apache.camel.quarkus.main.CamelMainRuntime.start(CamelMainRuntime.java:49)
	... 12 more
```
For some reason they use camel-main's service IP when binding the property "camel.main.port=tcp://10.217.5.161:80".