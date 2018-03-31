FROM ubuntu:14.04

RUN deb https://download.webmin.com/download/repository sarge contrib
RUN cd /root
RUN wget http://www.webmin.com/jcameron-key.asc
RUN sudo apt-key add jcameron-key.asc
RUN sudo apt-get install apt-transport-https
RUN sudo apt-get update
RUN sudo apt-get -y install webmin