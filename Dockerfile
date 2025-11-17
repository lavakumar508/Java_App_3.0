FROM eclipse-temurin:8-jdk
WORKDIR /app
COPY ./target/*.jar /app.jar
CMD ["java", "-jar", "/app.jar"]
