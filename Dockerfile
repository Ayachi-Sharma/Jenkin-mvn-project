
# Stage 1: Build the application using Maven and JDK
FROM maven:3.9-eclipse-temurin-21 AS builder

WORKDIR /app

COPY pom.xml .
COPY billing-core/pom.xml billing-core/pom.xml
COPY billing-web/pom.xml billing-web/pom.xml

# Resolve dependencies before copying source
RUN mvn dependency:go-offline

COPY billing-core/src billing-core/src
COPY billing-web/src billing-web/src

RUN mvn clean package

# Stage 2: Runtime image with Tomcat and JRE
FROM tomcat:11-jre21-temurin

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=builder /app/billing-web/target/billing-web-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/invoice-service.war

USER 1000:0

HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=3 CMD ["curl", "-f", "http://localhost:8080/invoice-service/"]

EXPOSE 8080

CMD ["catalina.sh", "run"]

