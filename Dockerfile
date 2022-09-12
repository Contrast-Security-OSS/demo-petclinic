FROM openjdk:8-jre-alpine
RUN mkdir /spring-petclinic
WORKDIR /spring-petclinic

#Add application
ADD ./spring-petclinic-1.5.1.jar /spring-petclinic/spring-petclinic-1.5.1.jar

#Add Contrast
ADD https://repository.sonatype.org/service/local/artifact/maven/redirect?r=central-proxy&g=com.contrastsecurity&a=contrast-agent&v=LATEST /opt/contrast/contrast.jar

#Enable Contrast
ENV JAVA_TOOL_OPTIONS='-javaagent:/opt/contrast/contrast.jar -Dcontrast.application.name=spring-petclinic'

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "spring-petclinic-1.5.1.jar"]