FROM alpine:3.4

ENV SQUID_CACHE_DIR=/opt/squid/cache
ENV SQUID_SSLDB_DIR=/opt/squid/ssl_db
ENV SQUID_LOG_DIR=/var/log/squid
ENV SQUID_USER=squid

RUN apk --no-cache add acf-squid curl openssl

COPY entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
