FROM openjdk:8u121-jre
MAINTAINER Matthew Ceroni <matthew.ceroni@smarsh.com>

#
# Some usefull environment variables
#
ENV VERSION 2.2.1
ENV USER archiva

#
# move data, temp, logs and repositories
#
RUN useradd -d /var/archiva -m $USER

#
# Download $VERSION and extract
#
RUN curl -sSLo /apache-archive-$VERSION-bin.tar.gz http://archive.apache.org/dist/archiva/$VERSION/binaries/apache-archiva-$VERSION-bin.tar.gz && \
      tar xfzv /apache-archive-$VERSION-bin.tar.gz --owner="$(id -u archiva)" --group="$(id -g archiva)" --directory /opt && \
      chown -R $USER:$USER /opt/apache-archiva-$VERSION && \
      ln -s /opt/apache-archiva-$VERSION /opt/apache-archiva && \
      rm -f /apache-archive-$VERSION-bin.tar.gz

# 
# our entry point script
#
COPY start-archiva.sh /

#
# switch to user archiva
#
USER $USER

#
# standard web ports exposed
#
EXPOSE 8080/tcp 8443/tcp

#
# create our volume
#
VOLUME [ "/var/archiva" ]

#CMD [ "/opt/apache-archiva/bin/archiva", "console" ]
ENTRYPOINT [ "/start-archiva.sh" ]
