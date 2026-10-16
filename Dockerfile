
FROM tomcat:11.0.26-jdk21-temurin

RUN rm -rf /usr/local/tomcat/webapps/*

COPY billing-web/target/billing-web-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/invoice-service.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
