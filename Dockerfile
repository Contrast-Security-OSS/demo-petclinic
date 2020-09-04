FROM openjdk:8-jre-alpine
RUN mkdir /spring-petclinic
WORKDIR /spring-petclinic

#Add application
ADD ./spring-petclinic-1.5.1.jar /spring-petclinic/spring-petclinic-1.5.1.jar

#Add Contrast
RUN mkdir /opt/contrast
RUN apk --no-cache add curl
RUN curl --fail --silent --location "https://repository.sonatype.org/service/local/artifact/maven/redirect?r=central-proxy&g=com.contrastsecurity&a=contrast-agent&v=LATEST" -o /opt/contrast/contrast.jar

#Enable Contrast
ENV JAVA_TOOL_OPTIONS='-javaagent:/opt/contrast/contrast.jar -Dcontrast.agent.java.standalone_app_name=spring-petclinic'

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "spring-petclinic-1.5.1.jar"]