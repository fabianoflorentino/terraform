FROM alpine:edge as build

LABEL maintainer="Fabiano Florentino"
LABEL email="fabianoflorentino@outlook.com"
LABEL terraform version="1.1.9"
LABEL image version="v0.1"

RUN adduser --disabled-password --gecos "" terraform \
    && apk --no-cache update \
    && apk --no-cache upgrade \
    && apk add --no-cache --upgrade terraform

USER terraform

ENTRYPOINT [ "sh" ]