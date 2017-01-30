#!/bin/ash
set -e

create_log_dir() {
  mkdir -p ${SQUID_LOG_DIR}
  chmod -R 755 ${SQUID_LOG_DIR}
  chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_LOG_DIR}
}

create_cache_dir() {
  mkdir -p ${SQUID_CACHE_DIR}
  chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_CACHE_DIR}
}

generate_ssldb() {
  if [ ! -e ${SQUID_SSLDB_DIR} ]; then
    echo "Createing ssl_db..."
    rm -rf ${SQUID_SSLDB_DIR}
    /usr/lib/squid/ssl_crtd -c -s ${SQUID_SSLDB_DIR}
    chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_SSLDB_DIR}
  fi
}

echo "Starting dnsmasq..."
dnsmasq -k

create_log_dir
create_cache_dir
generate_ssldb

if [ ! -d ${SQUID_CACHE_DIR}/00 ]; then
  echo "Initializing cache..."
  $(which squid) -N -f /etc/squid/squid.conf -z
fi
echo "Starting squid..."
exec $(which squid) -f /etc/squid/squid.conf -NYCd 1 ${EXTRA_ARGS}
