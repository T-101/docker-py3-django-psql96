FROM python:3.5-alpine

MAINTAINER Antti Rummukainen

VOLUME ["/opt/app"]
WORKDIR /opt/app
COPY requirements.txt .

RUN apk update && \
	apk --no-cache add --virtual build-deps \
		gcc \
		musl-dev \
		python3-dev=3.5.2-r2 && \
	apk --no-cache add \
	    postgresql-client \
		postgresql-dev && \
	rm -rf /var/cache/apk/* && \
	pip install --upgrade pip && \
	pip install -r requirements.txt && \
	apk del build-deps

EXPOSE 8000

# Copy script that waits for postgresql before running django
COPY docker/wait-for-postgres.sh /wait-for-postgres.sh

# Copy modified settings.py template which has django-environ bits set
COPY docker/django/project_template/ /usr/local/lib/python3.5/site-packages/django/conf/project_template/

COPY . .