# MULTISTAGE BUILD
# dev: build stage for development
FROM openjdk:8-jdk-alpine as dev

WORKDIR /spring-petclinic
ADD .mvn/ .mvn/
ADD mvnw pom.xml ./
# RUN ./mvnw dependency:resolve-plugins dependency:resolve 

# Add the source code
ADD src src

# Build the application JAR file
RUN ./mvnw clean install -Dmaven.test.skip=true

EXPOSE 8080
# ENTRYPOINT ["java", "-jar", "target/spring-petclinic-1.5.4.jar"]
ENTRYPOINT ["./mvnw", "spring-boot:run"]


# prod: build stage for production
# Define the base docker image for running the application on it's own
FROM openjdk:8-jre-alpine as prod
WORKDIR /spring-petclinic

# Add application JAR file
# ADD --from= target/spring-petclinic-1.5.1.jar /spring-petclinic/spring-petclinic-1.5.1.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "spring-petclinic-1.5.1.jar"]

# Pull the latest contrast/agent-java image from Docker Hub so we can copy the 
# agent JAR file over to our own image. Note that this image currently only 
# supports linux/amd64 so set --platform flag.
FROM --platform=linux/amd64 contrast/agent-java:latest as contrast-agent

# STAGE 2: spring-petclinic:contrast
# Add the Contrast agent and set environment variables for Contrast
FROM base as contrast

# Not currently working due to Sonatype repo issues
# ADD https://repository.sonatype.org/service/local/artifact/maven/redirect?r=central-proxy&g=com.contrastsecurity&a=contrast-agent&v=LATEST /opt/contrast/contrast.jar
COPY --from=contrast-agent /contrast/contrast-agent.jar /opt/contrast/contrast.jar

# Add Contrast configuration file with base config for this app
# ADD contrast_security.yaml /etc/contrast/java/contrast_security.yaml

# Enable Contrast by setting -javaagent as a Java Tool Option
ENV JAVA_TOOL_OPTIONS='-javaagent:/opt/contrast/contrast.jar'

# Optional: Set Contrast environment variables (overwrites values in contrast_security.yaml)
ENV CONTRAST__SERVER__NAME="docker-dev-petclinic"
ENV CONTRAST__SERVER__ENVIRONMENT="Development"



