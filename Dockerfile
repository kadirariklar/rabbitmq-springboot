FROM adoptopenjdk/maven-openjdk11:latest as maven-builder
WORKDIR /tmp
COPY . ./
ENV MAVEN_OPTS="-Xmx1024m -XX:MaxPermSize=128m"
RUN mvn clean package -DskipTests=true
FROM openjdk:11-jre-slim
ENV JAR_FILE=target/*.jar
COPY --from=maven-builder /tmp/$JAR_FILE /opt/app/
RUN mv /opt/app/*.jar /opt/app/app.jar
WORKDIR /opt/app
RUN chgrp -R 0 /opt/app && \
    chmod -R g=u /opt/app
ENV PORT 8080
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]