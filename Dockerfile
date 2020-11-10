# Builds a goaccess image from the current working directory:
FROM debian:buster

RUN sed -i -e's/ main/ main contrib non-free/g' /etc/apt/sources.list && \
  apt-get update && apt-get -y upgrade
RUN apt-get -y install git libmaxminddb-dev autoconf automake autopoint \
  gcc libbz2-dev libncursesw5-dev libglib2.0-dev libssl-dev cssmin build-essential \
  wget unzip geoipupdate
  
WORKDIR /usr/local/src

#RUN git clone https://github.com/allinurl/goaccess.git && \
#  cd goaccess && \
#  git checkout v1.4.1 && \
  
RUN wget https://tar.goaccess.io/goaccess-1.4.1.tar.gz && \
  tar -xzvf goaccess-1.4.1.tar.gz && \
  cd goaccess-1.4.1/ && \
  ./configure --enable-utf8 --enable-geoip=mmdb && \
  make && \
  make install 
  
RUN mkdir /var/lib/GeoIp
WORKDIR /var/lib/GeoIp
RUN wget https://download.db-ip.com/free/dbip-country-lite-2020-11.mmdb.gz && \
  gunzip dbip-country-lite-2020-11.mmdb.gz


EXPOSE 7890
ENTRYPOINT ["/usr/local/bin/goaccess --geoip-database=/var/lib/GeoIp/dbip-country-lite-2020-11.mmdb"]
CMD ["--help"]
