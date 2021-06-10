# Kubernetes w/Contrast Java agent Example

This guide provides a working example of setting up and configuring the Contrast Java agent within a kubernetes environment.   This guide assumes you have basic working knowledge of git, docker and kubernetes.

## Prerequisites

Setup a local kubernetes environment if you do not already have one available to you.  Below are a few of the available options.

- Install Docker & kubernetes, follow instructions on [https://docs.docker.com/docker-for-mac/install](https://docs.docker.com/docker-for-mac/install/)/
- Install and start Minikube, follow instructions on https://kubernetes.io/docs/tasks/tools/install-minikube/

Clone the following repo that will be used for this tutorial:

```shell
git clone https://github.com/Contrast-Security-OSS/demo-petclinic.git
```

## Building and setting up the Java application's image w/Contrast

* * *

Inspect the `Dockerfile`, you should note a few sections where the Contrast agent is added:

Line 11 fetches the latest Contrast Java agent.

```dockerfile
# Add contrast sensor package
RUN curl --fail --silent --location "https://repository.sonatype.org/service/local/artifact/maven/redirect?r=central-proxy&g=com.contrastsecurity&a=contrast-agent&v=LATEST" -o /opt/contrast/contrast.jar

```

Line 14 sets the JAVA_TOOL_OPTIONS to load our agent with the JVM.  Also note the `-Dcontrast.agent.java.standalone_app_name=spring-petclinic` parameter to set the application name along 

```dockerfile
COPY --from=contrast /tmp/contrast /opt/contrast
```

For more details on adding the Contrast agent to your application/image. [See our docker guide on the subject](https://support.contrastsecurity.com/hc/en-us/articles/360056810771-Java-agent-with-Docker).

* * *

1.  In your terminal, navigate to the cloned repo's folder and run the following command to build the docker image.

```shell
docker build . -t spring-petclinic:k8s --no-cache
```

2.  Tag and push your image to a local or public repo.

```shell
docker tag spring-petclinic:k8s example/spring-petclinic:k8s
```
```shell
docker push example/spring-petclinic:k8s
```

Now this image can be used in the kubernetes deployment.

## Setting up the Kubernetes environment

2.  Download the `contrast_security.yaml` and create a secret

YAML file should look like the following for our Java agent:

```yaml
api: 
  url: http(s)://<dns>/Contrast
  api_key: <apiKey>
  service_key: <serviceKey>
  user_name: agent_<hashcode>@<domain>
```

Create a secret using `kubectl`

```shell
kubectl create secret generic contrast-security --from-file=./contrast_security.yaml
```

> This secret can be used by all Java agents. So it is preferable to keep this generic and make all app level configuration changes with environmental variables.

3.  Create the applications deployment file and add the contrast_security secret. This will mount the file under `/etc/contrast/`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata: 
  name: petclinic
spec: 
  replicas: 1
  selector: 
    matchLabels: 
      component: petclinic
  template:
    metadata:
      labels:
        component: petclinic
    spec:
      containers:
      - name: petclinic
        image: contrastsecuritydemo/spring-petclinic:k8s
        ports: 
          - containerPort: 8080
        envFrom:
          - configMapRef:
              name: contrast-config  
        # Volume Mount for contrast_security.yaml  
        volumeMounts:
        - name: contrast-security
          readOnly: false
          mountPath: "/etc/contrast"
        resources:
          requests:
            cpu: 1.0
            memory: 2Gi
          limits:
            cpu: 2.0
            memory: 4Gi
      # Volume from contrast-security secret     
      volumes:
      - name: contrast-security
        secret:
          secretName: contrast-security
```

4.  Add application level configurations to setup logging, pointer to the `contrast_security.yaml` and any desired name/environment updates. A full list of configurations options are provided in [our documentation here](https://docs.contrastsecurity.com/en/environment-variables.html)

```yaml
env:
        - name: CONTRAST__APPLICATION__NAME
          value: "petclinic-k8s"
        - name: CONTRAST__SERVER__NAME
          value: "EKS-Core-Pod"
        - name: CONTRAST__SERVER__ENVIRONMENT
          value: "QA"
        - name: CONTRAST_CONFIG_PATH
          value: "/etc/contrast/contrast_security.yaml"
        - name: AGENT__LOGGER__STDOUT
          value: "true"
        - name: AGENT__LOGGER__LEVEL
          value: "INFO"
```

**Optionally:** these could also be defined via configmaps

Create a file called `contrast.properties` with the same environmental variables defined.

```shell
CONTRAST__SERVER__NAME=EKS-Core-Pod
CONTRAST__SERVER__ENVIRONMENT=qa
CONTRAST_CONFIG_PATH=/etc/contrast/contrast_security.yaml
AGENT__LOGGER__STDOUT=true
AGENT__LOGGER__LEVEL=INFO
```

Create the configmap

```shell
kubectl create configmap contrast-config --from-env-file=contrast.properties
```

Update the deployment file to reference the configmap.

```yaml
    spec:
      containers:
      - name: petclinic
        image: contrastsecuritydemo/spring-petclinic:k8s
        ports: 
          - containerPort: 8080
        envFrom:
          - configMapRef:
              name: contrast-config
```

5.  Apply the deployment file

```shell
kubectl apply -f petclinic_deployment.yaml
```

6.  Finally configure a load balancer to expose the application.

```shell
kubectl expose deployment petclinic --type=LoadBalancer --name=petclinic-lb
```

7.  Check on the deployed application in kubernetes and access the site at External-IP/port 8080

```shell
kubectl get all
```

The sources for this example can be found on our github repo: [demo-petclinic](https://github.com/Contrast-Security-OSS/demo-petclinic)

