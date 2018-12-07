FROM debian:stretch

COPY . /app

RUN apt-get update && apt-get install -y --no-install-recommends apt-transport-https ca-certificates gnupg2 git cron libxml2-utils jq && \
    echo 'deb https://apt.dockerproject.org/repo debian-jessie main' > /etc/apt/sources.list.d/docker.list && \
    apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
    apt update && \
    apt install -y docker-engine && \
    mv /app/cron/crontab /etc/cron.d/node-oracle-cron && \
    chmod 0644 /etc/cron.d/node-oracle-cron && \
    /usr/bin/crontab /etc/cron.d/node-oracle-cron && \
    chmod +x /app/entrypoint.sh && \
    chmod +x /app/scraper.sh && \
    chmod +x /app/build-image.sh && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["sh", "/app/entrypoint.sh"]