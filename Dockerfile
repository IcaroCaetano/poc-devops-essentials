# Etapa de build
FROM eclipse-temurin:21-jdk as build
WORKDIR /app
COPY . .
RUN ./mvnw clean package -DskipTests

# Etapa final
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
