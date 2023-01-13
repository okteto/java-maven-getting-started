FROM maven as build
WORKDIR /code
COPY . /code/
RUN ./mvnw --batch-mode --no-transfer-progress package

FROM gcr.io/distroless/java17-debian11
EXPOSE 8080
WORKDIR /app
COPY --from=build /code/target/*.jar .
CMD java -jar *.jar
