FROM ubuntu:16.04
MAINTAINER Tim Rhomberg <timrhomberg@hotmail.com>

RUN apt-get -qq update
RUN apt-get -y -qq install wget
RUN sed -i '$adeb https://download.webmin.com/download/repository sarge contrib' /etc/apt/sources.list
RUN cd /root
RUN wget http://www.webmin.com/jcameron-key.asc
RUN apt-key add jcameron-key.asc
RUN apt-get -y -qq install apt-transport-https
RUN apt-get -qq update
RUN apt-get -y install apt-utils
RUN rm /etc/apt/apt.conf.d/docker-gzip-indexes
RUN apt-get purge apt-show-versions
RUN rm /var/lib/apt/lists/*lz4
RUN apt-get -o Acquire::GzipIndexes=false update
RUN apt-get -y install apt-show-versions
RUN apt-get -y install webmin

HEALTHCHECK --interval=5m --timeout=3s CMD curl -f https://localhost:10000 || exit 1

EXPOSE 10000

CMD /usr/bin/touch /var/webmin/miniserv.log && /usr/sbin/service webmin restart && /usr/bin/tail -f /var/webmin/miniserv.log