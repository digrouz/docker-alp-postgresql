FROM centos:latest
LABEL maintainer "DI GREGORIO Nicolas <nicolas.digregorio@gmail.com>"

### Environment variables
ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US.UTF-8' \
    TERM='xterm' \
    PG_VERSION='9.6' \
    PATH='/usr/pgsql-$PG_VERSION/bin:$PATH' \
    PGDATA='/var/lib/pgsql/$PG_VERSION/data' 

### Install Application
RUN yum update -y && \
    yum-config-manager --save --setopt=base.exclude=postgresql* && \
    yum-config-manager --save --setopt=updates.exclude=postgresql* && \
    curl -L https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm -o /tmp/pgrepo.rpm && \
    yum localinstall -y /tmp/pgrepo.rpm && \
    yum install -y postgresql96-server && \
    yum install -y gcc git make && \
    git clone --depth 1 https://github.com/ncopa/su-exec /tmp/su-exec && \
    cd /tmp/su-exec && \
    make && \
    cp /tmp/su-exec/su-exec /usr/local/bin/su-exec && \
    yum history -y undo last && \
    mkdir /docker-entrypoint-initdb.d && \
    yum clean all && \
    rm -rf /tmp/* \
           /var/cache/yum/* \
           /var/tmp/*
    
# Expose volumes
VOLUME ["/var/lib/pgsql/${PG_VERSION}/data"]

# Expose ports
EXPOSE 5432

### Running User: not used, managed by docker-entrypoint.sh
#USER postgres

### Start postgres
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["postgres"]
