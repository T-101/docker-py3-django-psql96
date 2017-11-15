FROM postgres:9.6-alpine

MAINTAINER Antti Rummukainen

# Jump through hoops to get the glibc and fi_FI.UTF-8 locale compiled.
RUN apk update && \
    apk upgrade && \
    apk --no-cache add --virtual build-dependencies \
        ca-certificates \
        wget \
        gcc && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-2.25-r0.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-bin-2.25-r0.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-i18n-2.25-r0.apk && \
    apk add --virtual glibc-dependencies \
        glibc-bin-2.25-r0.apk \
        glibc-i18n-2.25-r0.apk \
        glibc-2.25-r0.apk && \
    rm \
        glibc-bin-2.25-r0.apk \
        glibc-i18n-2.25-r0.apk \
        glibc-2.25-r0.apk && \
    /usr/glibc-compat/bin/localedef -i fi_FI -f UTF-8 fi_FI.UTF-8 && \
    apk del build-dependencies && \
    apk del glibc-dependencies

# Enable the locale. It will be used to set the database locale and collation.
ENV LANG fi_FI.UTF-8

# Add database init script to be run at... database init!
ADD init-db.sh /docker-entrypoint-initdb.d/init-db.sh
