FROM eclipse-temurin:25.0.5_8-jdk-resolute AS dev

RUN apt-get update && \
    apt-get install -y --no-install-recommends inotify-tools=4.25.9.0-1 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
COPY . .

# The cache mount keeps the Maven repository, with the Maven distribution and
# the dependencies, in the Okteto Build Service, which reuses it between
# builds. The tests of the Okteto Manifest use the same cache
RUN --mount=type=cache,target=/root/.m2 \
    ./mvnw package -DskipTests

FROM eclipse-temurin:25.0.5_8-jre-resolute AS prod

COPY --from=dev /usr/src/app/target/helloworld-0.0.1.jar /usr/local/lib/hello-world.jar
CMD ["java", "-jar", "/usr/local/lib/hello-world.jar"]
