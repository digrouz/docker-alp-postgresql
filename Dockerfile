FROM alpine:latest
LABEL maintainer "DI GREGORIO Nicolas <nicolas.digregorio@gmail.com>"

### Environment variables
ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US.UTF-8' \
    TERM='xterm' \
    PGDATA='/var/lib/postgresql/data' \
    PG_VERSION='9.6'

### Install Application
RUN apk upgrade --no-cache && \
    apk add --no-cache --virtual=run-deps \
      tzdata \
      bash \
      su-exec \
      postgresql && \
    mkdir /docker-entrypoint-initdb.d && \
    rm -rf /tmp/* \
           /var/cache/apk/*  \
           /var/tmp/*
    
# Expose volumes
VOLUME ["/var/lib/postgresql/data"]

# Expose ports
EXPOSE 5432

### Running User: not used, managed by docker-entrypoint.sh
#USER postgres

### Start postgres
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["postgres"]
