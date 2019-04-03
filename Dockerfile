FROM gcr.io/gcp-runtimes/ubuntu_18_0_4:latest

LABEL maintainer="ask@dz0ny.dev"

ENV LANGUAGE "en_US.UTF-8"
ENV LC_ALL "en_US.UTF-8"
ENV LANG "en_US.UTF-8"
ENV DEBIAN_FRONTEND noninteractive

COPY build /build
RUN /build/build
RUN rm -rf /provision/bin/

ENV HOME "/var/www"
VOLUME [ "/var/www" ]
EXPOSE 80

COPY vendor /vendor
RUN ["chown", "www-data:www-data", "/vendor"]
USER www-data
RUN /vendor/init.sh
USER root

COPY templates /templates
COPY init.toml /init.toml

CMD ["/sbin/wrap2", "-config=/init.toml", "-logger=/tmp/logger.sock"]
