# Getting Started on Okteto with Java (Maven)

This example shows how to leverage [Okteto](https://github.com/okteto/okteto) to develop a Java Sample App directly in Kubernetes. The Java Sample App is deployed using raw Kubernetes manifests.

Okteto works in any Kubernetes cluster by reading your local kubeconfig file. If you need access to a Kubernetes cluster, [Okteto Cloud](https://cloud.okteto.com) gives you free access to secure Kubernetes namespaces, compatible with any Kubernetes tool.

## Step 1: Deploy the Java Sample App

Get a local version of the Java Sample App by executing the following commands in your local shell:

```console
$ git clone https://github.com/okteto/java-maven-getting-started
$ cd java-maven-getting-started
```

The `k8s.yml` file contains the raw Kubernetes manifests to deploy the Java Sample App. Run the application by executing:

```console
$ kubectl apply -f k8s.yml
```

```console
deployment.apps "hello-world" created
service "hello-world" created
```

This is cool! You typed one command and a dev version of your application just runs 😎. 

## Step 2: Start your development environment in Kubernetes

With the Java Sample Application deployed, run the following command:

```console
$ okteto up
```

```console
 ✓  Development environment activated
 ✓  Files synchronized
    Namespace: pchico83
    Name:      hello-world
    Forward:   8080 -> 8080
               8088 -> 8088

okteto>
```

The `okteto up` command starts a [Kubernetes development environment](https://okteto.com/docs/reference/development-environment/index.html), which means:

- The Java Sample App container is updated with the Docker image `maven:latest`. This image contains the required dev tools to build, test and run a Java application.
- A [file synchronization service](https://okteto.com/docs/reference/file-synchronization/index.html) is created to keep your changes up-to-date between your local filesystem and your application pods.
- Attach a volume to persist the Maven cache in your Kubernetes development environment.
- Container ports 8080 (the application) and 8088 (the debugger) are forwarded to localhost.
- You have a remote shell in the development environment. Build, test and run your application as if you were in your local machine.

> All of this (and more) can be customized via the `okteto.yml` [manifest file](https://okteto.com/docs/reference/manifest/index.html)

To run the application execute in the remote shell:

```console
okteto> mvn spring-boot:run
```

The first time you run the application, Maven will download your dependencies and compile your application. Wait for this proccess to finish and test your application by running the command below in a local shell:

```console
$ curl localhost:8080
```

```console
Hello world REST API!
```

## Step 3: Develop directly in Kubernetes

Open `src/main/java/com/okteto/helloworld/RestHelloWorld.java` in your favorite local IDE and modify the response message on line 11 to be *Hello world REST API from the cluster!*. Save your changes. 

```java
package com.okteto.helloworld;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class RestHelloWorld {
	
	@GetMapping("/")
	public String sayHello() {
		return "Hello world REST API from the cluster!";
	}
}
```

Your IDE will auto compile only the necessary `*.class` files which will be synchronized by Okteto to your application in Kubernetes. Take a look at the reemote shell and notice how the changes are detected by Spring Boot and automatically hot reloaded. To enable Spring Boot hot reloads you need to import the `spring-boot-devtools` dependency in your application: 

```console
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-devtools</artifactId>
</dependency>
```

Call your application to validate the changes:

```console
$ curl localhost:8080
```

```console
Hello world REST API from the cluster!
```

Cool! Your code changes were instantly applied to Kubernetes. No commit, build or push required 😎!

## Step 4: Debug directly in Kubernetes

Okteto enables you to debug your applications directly from your favorite IDE. Let's take a look at how that works in Eclipse, one of the most popular IDEs for Java development.

Open the _Debug configuration_  dialog, add a new Remote Java Application debug configuration, and point it to `localhost:8088`. Click the Debug button to start debugging. Add a breakpoint on `src/main/java/es/okteto/helloworld/RestHelloWorld.java`, line 11, and call your application by running the command below from your local terminal.

```console
$ curl localhost:8080
```

The execution will halt at your breakpoint. You can then inspect the request, the available variables, etc...

## Step 5: Cleanup

Cancel the `okteto up` command by pressing `ctrl + c` + `ctrl + d` and run the following commands to remove the resources created by this guide: 

```console
$ okteto down
 ✓  Development environment deactivated
```

```console
$ kubectl delete -f k8s.yml
deployment.apps "hello-world" deleted
service "hello-world" deleted
```
