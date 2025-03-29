FROM maven:3.8.6-openjdk-17-slim as build

WORKDIR /app

COPY pom.xml ./

COPY src ./

RUN mvn clean package -DskipTests

FROM gcr.io/distroless/java17

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 9090

ENTRYPOINT [ "java", "-jar", "/app/app.jar" ]
