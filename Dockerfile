FROM maven:3-jdk-7-alpine as build

WORKDIR /build

COPY pom.xml .
COPY settings.xml .
COPY brouter-codec brouter-codec
COPY brouter-core brouter-core
COPY brouter-expressions brouter-expressions
COPY brouter-map-creator brouter-map-creator
COPY brouter-mapaccess brouter-mapaccess
COPY brouter-routing-app brouter-routing-app
COPY brouter-server brouter-server
COPY brouter-util brouter-util

RUN mvn clean install -pl '!brouter-routing-app' '-Dmaven.javadoc.skip=true' -DskipTests



FROM openjdk:7-jre-alpine

ENV CLASSPATH="brouter-server.jar"
ENV SEGMENTSPATH="segments"
ENV PROFILESPATH="profiles"
ENV CUSTOMPROFILESPATH="customprofiles"

WORKDIR /app
RUN mkdir $CUSTOMPROFILESPATH $PROFILESPATH $SEGMENTSPATH

COPY --from=build /build/brouter-server/target/brouter*with-dependencies.jar $CLASSPATH
COPY misc/profiles2 $PROFILESPATH
COPY misc/scripts/standalone/server.sh server.sh
COPY get_segments.sh get_segments.sh

EXPOSE 17777

CMD ./server.sh
