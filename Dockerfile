FROM maven as builder
COPY . /code/
WORKDIR /code
RUN mvn package

FROM openjdk:8-jre
EXPOSE 8080
WORKDIR /app
COPY --from=builder /code/target/*.jar .
CMD java -jar *.jar
