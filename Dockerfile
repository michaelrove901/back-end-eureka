FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /workspace
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests -B

FROM openjdk:21-jdk-slim
COPY --from=build /workspace/target/*.jar /app.jar
ENV EUREKA_PORT=8761
EXPOSE ${EUREKA_PORT}
ENTRYPOINT ["sh","-c","java -Dspring.profiles.active=prod -Dserver.port=${EUREKA_PORT} -jar /app.jar"]
