# Spring PetClinic: A deliberately insecure Java web application

This sample application is based on https://github.com/Contrast-Security-OSS/spring-petclinic

**Warning**: The computer running this application will be vulnerable to attacks, please take appropriate precautions.

# Running standalone

You can run PetClinic locally on any machine with Java 1.8 RE installed.

1. Place a `contrast_security.yaml` file into the application's root folder.
1. Place a `contrast.jar` into the application's root folder.
1. Run the application using: 
```sh
java -javaagent:contrast.jar -Dcontrast.config.path=contrast_security.yaml  -Dcontrast.application.name=spring-petclinic -jar spring-petclinic-1.5.1.jar [--server.port=8080] [--server.address=localhost] 
```
1. Browse the application at http://localhost:8080/

# Running in Docker

You can run PetClinic within a Docker container. 

1. Place a `contrast_security.yaml` file into the application's root folder.
1. Build the PetClinic container image using `./1-Build-Docker-Image.sh`. The Contrast agent is added automatically during the Docker build process.
1. Run the container using `docker run -v $PWD/contrast_security.yaml:/etc/contrast/java/contrast_security.yaml -p 8080:8080 spring-petclinic:1.5.1`
1. Browse the application at http://localhost:8080/

# Running in Terraform with Docker locally

You can run PetClinic within a Docker container using Terraform. 

1. Place a `contrast_security.yaml` file into the `terraform-local` folder.
1. Install Terraform from here: https://www.terraform.io/downloads.html.
1. Install PyYAML using `pip install PyYAML`.
1. Build the PetClinic container image using `./1-Build-Docker-Image.sh`. The Contrast agent is added automatically during the Docker build process.
1. Open a terminal and cd to the `terraform-local` folder.
1. Run `terraform init` to download the required plugins.
1. Run `terraform plan` and check the output for errors.
1. Run `terraform apply` to run the image in Docker, this will output the web address for the application.
1. Run `terraform destroy` when you would like to stop the app service and release the resources.
1. Browse the application at http://localhost:8081/

# Running in Azure (Container Image) using Terraform

## Pre-Requisites

1. Place a `contrast_security.yaml` file into the application's root folder.
1. Install Terraform from here: https://www.terraform.io/downloads.html.
1. Install PyYAML using `pip install PyYAML`.
1. Install the Azure cli tools using `brew update && brew install azure-cli`.
1. Log into Azure to make sure you cache your credentials using `az login`.
1. Edit the [variables.tf](variables.tf) file (or add a terraform.tfvars) to add your initials, preferred Azure location, app name, server name and environment.
1. Run `terraform init` to download the required plugins.
1. Run `terraform plan` and check the output for errors.
1. Run `terraform apply` to build the infrastructure that you need in Azure, this will output the web address for the application.
1. Run `terraform destroy` when you would like to stop the app service and release the resources.

# Running automated tests

There is a test script which you can use to reveal vulnerabilities which requires node and puppeteer.

1. Install Node, NPM, Playwright and Chrome.
1. From the app folder run `npx playwright test`.

## Updating the Docker Image

You can re-build the docker image (used by Terraform) by running two scripts in order:

* 1-Build-Docker-Image.sh
* 2-Deploy-Docker-Image-To-Docker-Hub.sh
