#
# Build stage
#
#FROM maven:3.6.0-jdk-11-slim AS build
FROM maven:3.8.6-openjdk-11-slim AS build
COPY . .

RUN mvn clean install

#
# Package stage
#
FROM openjdk:11-jre-slim
LABEL maintainer="dinesh@dman.cloud"
COPY --from=build /target/Uber.jar /usr/local/lib/demo.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/usr/local/lib/demo.jar"]
