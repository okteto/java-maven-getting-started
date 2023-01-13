FROM maven:3.8.7-eclipse-temurin-17 as build
WORKDIR /code
COPY . /code/
RUN mvn --batch-mode --no-transfer-progress package

FROM gcr.io/distroless/java17-debian11
EXPOSE 8080
WORKDIR /app
COPY --from=build /code/target/*.jar .
CMD java -jar *.jar
