FROM maven as build
WORKDIR /okteto/src
RUN mkdir /okteto/src/target
COPY . /okteto/src/

RUN --mount=type=cache,target=/root/.m2 --mount=type=cache,target=/okteto/cache \
    cp -a . /okteto/cache && \
    cd /okteto/cache && \
    mvn package && \
    cp -a /okteto/cache/target /okteto/src

FROM openjdk:8-jre
EXPOSE 8080
WORKDIR /app
COPY --from=build /okteto/src/target/helloworld-0.0.1.jar .
CMD java -jar *.jar
