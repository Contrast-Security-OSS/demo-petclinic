FROM openjdk:8-jre-alpine
RUN mkdir /spring-petclinic
WORKDIR /spring-petclinic

#Add application
ADD ./spring-petclinic-1.5.1.jar /spring-petclinic/spring-petclinic-1.5.1.jar

#Add Contrast
COPY --from=contrast/agent-java:5 /contrast/contrast-agent.jar /opt/contrast/contrast.jar

#Enable Contrast
ENV JAVA_TOOL_OPTIONS='-javaagent:/opt/contrast/contrast.jar -Dcontrast.application.name=spring-petclinic'

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "spring-petclinic-1.5.1.jar"]