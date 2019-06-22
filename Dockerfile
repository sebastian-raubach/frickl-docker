FROM tomcat:8-jdk8

LABEL maintainer="sebastian@raubach.co.uk"

# Clone the Frickl server code and client code
RUN git clone https://github.com/sebastian-raubach/frickl-web-server.git /opt/frickl-server && \
    git clone https://github.com/sebastian-raubach/frickl-web /opt/frickl

# Install node.js
RUN apt-get update && \
    curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get update && \
    apt-get install -y nodejs

# Copy a configuration for the server
COPY build.properties /opt/frickl-server

# Download Ant and build the server code
RUN wget https://www-eu.apache.org/dist//ant/binaries/apache-ant-1.10.6-bin.tar.gz -P /tmp/
RUN tar xvzf /tmp/apache-ant-1.10.6-bin.tar.gz -C /opt/
RUN /opt/apache-ant-1.10.6/bin/ant -f /opt/frickl-server/build.xml war
RUN mkdir -p /usr/local/tomcat/webapps
RUN cp /opt/frickl-server/frickl.war /usr/local/tomcat/webapps/

# Build the client code
WORKDIR /opt/frickl
RUN rm .env && \
    echo "VUE_APP_BASE_URL=/frickl/" > .env
RUN npm i && \
    npm run build && \
    mkdir /usr/local/tomcat/webapps/frickl-web && \
    cp -a /opt/frickl/dist/. /usr/local/tomcat/webapps/frickl-web

COPY tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml

WORKDIR /
