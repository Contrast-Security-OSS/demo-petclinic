# STAGE 1: spring-petclinic:base
# Define the base docker image for running the application on it's own
FROM openjdk:8-jre-alpine as base
RUN mkdir /spring-petclinic
WORKDIR /spring-petclinic

# Add application JAR file
ADD ./spring-petclinic-1.5.1.jar /spring-petclinic/spring-petclinic-1.5.1.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "spring-petclinic-1.5.1.jar"]

# STAGE 2: spring-petclinic:contrast
# Add the Contrast agent and set environment variables for Contrast
FROM base as contrast

# Add Contrast agent JAR file
ADD https://repository.sonatype.org/service/local/artifact/maven/redirect?r=central-proxy&g=com.contrastsecurity&a=contrast-agent&v=LATEST /opt/contrast/contrast.jar

# Add Contrast configuration file with base config for this app
ADD contrast_security.yaml /etc/contrast/java/contrast_security.yaml

# Enable Contrast by setting -javaagent as a Java Tool Option
ENV JAVA_TOOL_OPTIONS='-javaagent:/opt/contrast/contrast.jar'

# Oprional: Set Contrast environment variables (overwrites values in contrast_security.yaml)
ENV CONTRAST__SERVER__NAME="docker-dev-petclinic"
ENV CONTRAST__SERVER__ENVIRONMENT="Development"



