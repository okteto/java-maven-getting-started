FROM maven:3-eclipse-temurin-17 AS build
WORKDIR /code
COPY . /code/
RUN mvn package

FROM eclipse-temurin:17-jre
EXPOSE 8080
WORKDIR /app
COPY --from=build /code/target/*.jar .
CMD java -jar *.jar
