FROM openjdk:8-jre-alpine
RUN apk update && apk add bash
WORKDIR /app
COPY /target/Uber.jar /app
EXPOSE 8080
CMD ["java", "-jar", "Uber.jar"]
