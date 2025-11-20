# Java 8 version
FROM eclipse-temurin:8-jdk-jammy

# Copy the already-built JAR
COPY target/simple-Api-java8-0.0.1-SNAPSHOT.jar app.jar

# Run it
ENTRYPOINT ["java", "-jar", "/app.jar"]