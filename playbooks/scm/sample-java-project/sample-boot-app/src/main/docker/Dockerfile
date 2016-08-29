FROM frolvlad/alpine-oraclejdk8:slim
VOLUME /tmp
ARG appversion
ADD app.jar app.jar
RUN sh -c 'touch /app.jar'
EXPOSE 8080
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]