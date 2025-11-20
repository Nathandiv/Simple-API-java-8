# Step-by-Step Instructions

## 1. Install All Required JDKs (one time only)
in your terminal RUN

sudo apt update
sudo apt install openjdk-8-jdk openjdk-11-jdk -y

Why? Because Spring Boot 3 needs Java 17+, but we want to support very old systems that only have Java 8 or 11.

## 2. Switch Java Version (do this every time you work on a different version)

Check current version
in your terminal RUN

java -version

### Switch to Java 8
in your terminal RUN

sudo update-alternatives --config java   # pick the Java 8 line
sudo update-alternatives --config javac  # pick the Java 8 line

#### Same for Java 11 or back to 21

## 3. Make a Clean Copy of Your Original Project

 Java 8 version
cp -r ~/Desktop/sipmle-Api ~/Desktop/simple-Api-java8
cd ~/Desktop/simple-Api-java8

### Java 11 version (do this later)
cp -r ~/Desktop/sipmle-Api ~/Desktop/simple-Api-java11


## 4. Replace pom.xml with the Correct One (THE MOST IMPORTANT STEP)
For Java 8 – create/replace pom.xml with this exact content:

<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.7.18</version>        <!-- ONLY 2.7.x works with Java 8/11 -->
        <relativePath/>
    </parent>

    <groupId>com.example</groupId>
    <artifactId>simple-Api-java8</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>simple-Api-java8</name>
    <description>Minimal Spring Boot API running on Java 8</description>

    <properties>
        <java.version>1.8</java.version>   <!-- THIS LINE IS CRITICAL -->
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
            <scope>runtime</scope>
            <optional>true</optional>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>


For Java 11 – same file, only change these 4 lines:

## 5. Build the JAR

in your Project terminal RUN

./mvnw clean package

You will get: target/simple-Api-java8-0.0.1-SNAPSHOT.jar (or java11)

## 6. Test the JAR

java -jar target/simple-Api-java8-0.0.1-SNAPSHOT.jar

## 7. Create Dockerfile (for container)
Java 8 Dockerfile (create file named exactly Dockerfile):

FROM eclipse-temurin:8-jdk-jammy
COPY target/simple-Api-java8-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]

### Start Docker if it's not running
sudo systemctl start docker

### Build image
docker build -t simple-api-java8 .          # for Java 8
docker build -t simple-api-java11 .         # for Java 11

### Run (use different ports so they don't clash)
docker run -p 8080:8080 simple-api-java8
docker run -p 8081:8080 simple-api-java11

## 7. Create Dockerfile (for container)
Java 8 Dockerfile (create file named exactly Dockerfile):

FROM eclipse-temurin:8-jdk-jammy
COPY target/simple-Api-java8-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]

## 8. Build & Run Docker Image

### Start Docker if it's not running
sudo systemctl start docker

### Build image
docker build -t simple-api-java8 .          # for Java 8
docker build -t simple-api-java11 .         # for Java 11

### Run (use different ports so they don't clash)
docker run -p 8080:8080 simple-api-java8
docker run -p 8081:8080 simple-api-java11

## COMMON ERRORS & SOLUTIONS

Error: Cannot connect to the Docker daemon at unix:///var/run/docker.sock
Cause: Docker service not running
Fix: sudo systemctl start docker
     (also run: sudo systemctl enable docker  to start on boot)

Error: The version cannot be empty (Lombok error)
Cause: Spring Boot 2.7.x + old Lombok configuration
Fix: Removed Lombok dependency completely (we don't use any Lombok annotations)

Error: Build failed after downgrading Spring Boot
Cause: Still had Lombok + maven-compiler-plugin block
Fix: Deleted maven-compiler-plugin and Lombok from pom.xml

Error: Wrong Java version used during build (still Java 21)
Cause: System default Java not changed
Fix: sudo update-alternatives --config java
     sudo update-alternatives --config javac
     Then verify with: java -version

Error: cp: cannot stat ... No such file or directory
Cause: Original folder name was sipmle-Api (typo)
Fix: Run ls ~/Desktop to see exact name, then use correct folder name

Error: Docker build took a long time first time
Cause: Downloading large Java base image (~250 MB)
Fix: Normal! Only happens once. All future builds are very fast.


