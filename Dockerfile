#FROM openjdk:8-jre-alpine
#RUN apk update && apk add bash
#WORKDIR /app
#COPY /target/Uber.jar /app
#EXPOSE 8080
#CMD ["java", "-jar", "Uber.jar"]

#
# Build stage
#
FROM maven:3.6.0-jdk-11-slim AS build
COPY src /home/app/src
COPY pom.xml /home/app
RUN mvn clean install

#
# Package stage
#
FROM openjdk:11-jre-slim
COPY --from=build /home/app/target/Uber.jar /usr/local/lib/demo.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/usr/local/lib/demo.jar"]
