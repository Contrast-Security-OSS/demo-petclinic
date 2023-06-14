FROM openjdk:8-jre-alpine
RUN mkdir /spring-petclinic
WORKDIR /spring-petclinic

#Add application
ADD ./spring-petclinic-1.5.1.jar /spring-petclinic/spring-petclinic-1.5.1.jar

# Copy the required agent files from the official Contrast agent image.
COPY --from=contrast/agent-java:latest /contrast/contrast-agent.jar /opt/contrast/contrast.jar

#Enable Contrast
ENV JAVA_TOOL_OPTIONS='-javaagent:/opt/contrast/contrast.jar'

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "spring-petclinic-1.5.1.jar"]
