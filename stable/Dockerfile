FROM       ubuntu:trusty
MAINTAINER Abe Voelker <abe@abevoelker.com>

# Provide a custom nginx.conf, tweaked for Docker use
COPY nginx.conf /data/conf/

# Ensure UTF-8 locale
COPY locale /etc/default/locale
RUN \
  locale-gen en_US.UTF-8 &&\
  DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales &&\
# Install build dependencies
  apt-get update &&\
  DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common &&\
# Add nginx PPA
  apt-add-repository ppa:nginx/stable &&\
# Update apt cache with PPA
  apt-get update &&\
# Install nginx
  DEBIAN_FRONTEND=noninteractive apt-get install -y nginx &&\
# Copy default config files to /data
  /bin/bash -c "cp -a /etc/nginx/{conf.d,sites-enabled} /data/" &&\
# Clean up APT and temporary files when done
  apt-get clean &&\
  DEBIAN_FRONTEND=noninteractive apt-get remove --purge -y software-properties-common &&\
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ["/var/cache/nginx", "/var/log/nginx"]

CMD ["nginx", "-c", "/data/conf/nginx.conf"]

EXPOSE 80 443
