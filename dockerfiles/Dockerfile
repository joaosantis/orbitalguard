# =================================================================
# OrbitalGuard - Dockerfile
# Global Solution 2026/2 - DevOps Tools & Cloud Computing
# Multi-stage build: compila com Maven, executa com JRE Alpine
# =================================================================

# Stage 1: Build com Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY orbitalguard-api/pom.xml .
RUN mvn dependency:go-offline -q
COPY orbitalguard-api/src ./src
RUN mvn package -DskipTests -q

# Stage 2: Runtime com JRE Alpine (imagem minima)
FROM eclipse-temurin:17-jre-alpine
WORKDIR /orbitalguard

RUN addgroup -S orbital && adduser -S orbital -G orbital

COPY --from=build /app/target/orbitalguard-api-1.0.0.jar app.jar
RUN chown orbital:orbital app.jar

USER orbital
ENV APP_ENV=production
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
