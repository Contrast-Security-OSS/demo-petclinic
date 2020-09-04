#!/bin/bash

echo "Please log in using your Docker Hub credentials to update the container image"
docker login
docker tag spring-petclinic:1.5.1 contrastsecuritydemo/spring-petclinic:1.5.1
docker push contrastsecuritydemo/spring-petclinic:1.5.1
