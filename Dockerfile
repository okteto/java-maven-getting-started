FROM eclipse-temurin:25.0.5_8-jdk-resolute AS dev

RUN apt-get update && \
    apt-get install -y --no-install-recommends inotify-tools=4.25.9.0-1 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
COPY mvnw pom.xml ./
COPY .mvn .mvn
RUN ./mvnw dependency:go-offline
COPY . .
RUN ./mvnw package -DskipTests

FROM eclipse-temurin:25.0.5_8-jre-resolute AS prod

COPY --from=dev /usr/src/app/target/helloworld-0.0.1.jar /usr/local/lib/hello-world.jar
CMD ["java", "-jar", "/usr/local/lib/hello-world.jar"]
