FROM tomcat:8-jdk8

LABEL maintainer="sebastian@raubach.co.uk"

COPY tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml
