# Java Sample App (Maven)

This example shows how to leverage [Okteto](https://github.com/okteto/okteto) to develop a Java Sample App directly in Kubernetes. The Java Sample App is deployed using raw Kubernetes manifests.

Okteto works in any Kubernetes cluster by reading your local kubeconfig file. If you need easy access to a Kubernetes cluster, [Okteto Cloud](https://cloud.okteto.com) gives you free access to 4CPUs and 8Gb virtual Kubernetes clusters.

## Step 1: Deploy the Java Sample App

Get a local version of the Java Sample App by executing the following commands in your local terminal:

```console
$ git clone https://github.com/okteto/java-maven-getting-started
$ cd java-maven-getting-started
```

The `k8s.yml` file contains the raw Kubernetes manifests that we will use in this guide to deploy the application in the cluster. Okteto works however independently of your common deployment practices or tools.

Run the Java Sample App by executing:

```console
$ kubectl apply -f k8s.yml
deployment.apps "hello-world" created
service "hello-world" created
```

> If you don't have `kubectl` installed, follow this [guide](https://kubernetes.io/docs/tasks/tools/install-kubectl/).

## Step 2: Install the Okteto CLI

Install the Okteto CLI by following our [installation guides](https://github.com/okteto/okteto/blob/master/docs/installation.md).

## Step 3: Create your ephemeral development environment

With the app deployed, you can start your ephemeral development environment by running the following command:

```console
$ okteto up
 ✓  Persistent volume provisioned
 ✓  Files synchronized
 ✓  Okteto Environment activated
    Namespace: pchico83
    Name:      hello-world
    Forward:   8080 -> 8080
               8088 -> 8088

okteto>
```

The `okteto up` command will automatically start an ephemeral development environment, which means:

- The Java Sample App container is updated with the docker image `maven`. This image contains the required dev tools to build, test and run the Java Sample App. Enjoy the advantages of having development environments as code.
- Create a bidirectional file synchronization service to keep your changes up-to-date between your local filesystem and your remote containers. Moving diff of code through the internet is way faster than moving Docker layers.
- Forward the container ports 8080 (the application) and 8088 (the debugger) to localhost.
- Start a terminal into the remote container. Build, test and run your application as if you were in your local machine.

Now run your application by executing the following command:

```console
okteto> mvn spring-boot:run
[INFO] Scanning for projects...
...

```

You can now access the Java Sample App at http://localhost:8080.

## Step 4: Develop directly in Kubernetes

Now things get more exciting. Edit the file `src/main/java/es/okteto/helloworld/RestHelloWorld.java` and modify the hello world message on line 11. Save your changes. You IDE will autocompile the necessary `*.class` files which will be synched to the the remote container. Note how the chages are detected by the `mvn spring-boot:run` command.

Go back to the browser and reload the page. Notice how your changes are instantly applied. No commit, build or push required 😎! 

Attach a debugger from your favourite IDE to `localhost:8088`  and you will be able to debug you applications as if it was running locally.

## Step 5: Cleanup

Cancel the `okteto up` command by pressing `ctrl + c` + `ctrl + d` and run the following commands to remove the resources created by this guide: 

```console
$ okteto down -v
 ✓  Okteto Environment deactivated
 ✓  Persistent volume deleted
```

```console
$ kubectl delete -f k8s.yml
deployment.apps "hello-world" deleted
service "hello-world" deleted
```
