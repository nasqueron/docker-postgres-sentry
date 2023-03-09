FROM postgres:9.6

# Install wal2json
ENV WAL2JSON_VERSION 0.0.2
RUN apt-get update ; apt-get install -y \
        wget \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /usr/local/share/postgres-init \
    && wget -O $(pg_config --pkglibdir)/wal2json.so https://github.com/getsentry/wal2json/releases/download/$WAL2JSON_VERSION/wal2json-Linux-x86_64-glibc.so

COPY files/pg_hba.conf /usr/local/share/postgres-init/
COPY files/provision-init-config.sh /docker-entrypoint-initdb.d/

CMD ["postgres", "-c", "wal_level=logical", "-c", "max_replication_slots=1", "-c", "max_wal_senders=1"]
