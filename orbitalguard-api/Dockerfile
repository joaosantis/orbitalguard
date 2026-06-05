# Stage 1 - Build
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -q
COPY src ./src
RUN mvn package -DskipTests -q

# Stage 2 - Runtime
FROM eclipse-temurin:17-jre-alpine

# Diretorio de trabalho da aplicacao
WORKDIR /orbitalguard

# Criacao de usuario nao privilegiado
RUN addgroup -S orbital && adduser -S orbital -G orbital

# Copia do artefato e ajuste de permissao
COPY --from=build /app/target/orbitalguard-api-1.0.0.jar app.jar
RUN chown orbital:orbital app.jar

# Usuario nao root em execucao
USER orbital

# Variavel de ambiente da aplicacao
ENV APP_ENV=production

# Porta da aplicacao
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
