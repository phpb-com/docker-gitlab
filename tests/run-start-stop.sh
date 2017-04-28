#!/bin/bash
set -e

REGISTRY_IMAGE="$1"
TEST_BASE_DIR="$2"
DB="$3"

TEST_RANDOM_STRING="fc92Ng2of8yJRguajyWCj6Yhzz7Byow7ibWGyWvy71EbERf0eGxIhWduDWghg7Ln"

echo "Preparing artifacts directory"
mkdir -p "${TEST_BASE_DIR}"/logs
chmod 777 "${TEST_BASE_DIR}"/logs

echo "Pulling docker container ${REGISTRY_IMAGE} ..."
docker pull ${REGISTRY_IMAGE}

if [[ "${DB}" == "mysql" ]]; then

    export DB_ADAPTER="mysql2"
    export DB_CONT="gitlab-mysql"
    export DB_LINK="${DB_CONT}:mysql"

    echo "Pulling and starting mysql containers ..."
    docker pull mariadb:latest
    docker run --name="${DB_CONT}" \
           --env='MYSQL_DATABASE=gitlabhq_production' \
           --env='MYSQL_USER=gitlab' \
           --env='MYSQL_PASSWORD=password' \
           --env='MYSQL_RANDOM_ROOT_PASSWORD=yes' \
           -d mariadb:latest \
           --character-set-server=utf8 \
           --collation-server=utf8_unicode_ci \
           --innodb-file-format=barracuda \
           --innodb-file-per-table=1 \
           --innodb-large-prefix=1 \
           --default-storage-engine=InnoDB

elif [[ "${DB}" == "pgsql" ]]; then

    export DB_ADAPTER="postgresql"
    export DB_CONT="gitlab-postgresql"
    export DB_LINK="${DB_CONT}:postgresql"

    echo "Pulling and starting postgresql containers ..."
    docker pull gotfix/postgresql:latest
    docker run --name="${DB_CONT}" \
           --env='DB_NAME=gitlabhq_production' \
           --env='DB_EXTENSION=pg_trgm' \
           --env='DB_USER=gitlab' \
           --env='DB_PASS=password' \
           -d gotfix/postgresql:latest

fi

echo "Pulling and starting redis containers ..."
docker pull gotfix/redis:latest
docker run --name=gitlab-redis -d gotfix/redis:latest

echo "Starting ${REGISTRY_IMAGE} container, and linking to ${DB_LINK}..."
docker run --name=gitlab-test -d \
       --link="${DB_LINK}" --link=gitlab-redis:redisio \
       --publish=40022:22 --publish=40080:80 \
       --env="GITLAB_PORT=40080" --env="GITLAB_SSH_PORT=40022" \
       --env="GITLAB_SECRETS_DB_KEY_BASE=${TEST_RANDOM_STRING}" \
       --env="GITLAB_SECRETS_SECRET_KEY_BASE=${TEST_RANDOM_STRING}" \
       --env="GITLAB_SECRETS_OTP_KEY_BASE=${TEST_RANDOM_STRING}" \
       --env="GITLAB_MONITOR_ENABLED=true" \
       --env="GITLAB_PAGES_ENABLED=true" \
       --env="GITLAB_PAGES_EXTERNAL_HTTP_IP=1.1.1.1" \
       --env="GITLAB_PROJECTS_SNIPPETS=true" \
       --env="GITLAB_NOTIFY_PUSHER=true" \
       --env="GITLAB_MATTERMOST_ENABLED=true" \
       --env="GITLAB_RELATIVE_URL_ROOT=/git" \
       --env="GITLAB_TRUSTED_PROXIES=1.1.1.1" \
       --env="GITLAB_REGISTRY_ENABLED=true" \
       --env="GITLAB_HTTPS=true" \
       --env="GITLAB_BACKUP_SCHEDULE=daily" \
       --env="GITLAB_BACKUP_TIME=01:00" \
       --env="GITLAB_BACKUP_SKIP=registry" \
       --env="NGINX_RETAIN_IP_HEADER=true" \
       --env="SMTP_ENABLED=true" \
       --env="IMAP_ENABLED=false" \
       --env="OAUTH_ENABLED=true" \
       --env="OAUTH_GOOGLE_API_KEY=${TEST_RANDOM_STRING}" \
       --env="OAUTH_GOOGLE_APP_SECRET=${TEST_RANDOM_STRING}" \
       --env="OAUTH_FACEBOOK_API_KEY=${TEST_RANDOM_STRING}" \
       --env="OAUTH_FACEBOOK_APP_SECRET=${TEST_RANDOM_STRING}" \
       --env="OAUTH_TWITTER_API_KEY=${TEST_RANDOM_STRING}" \
       --env="OAUTH_TWITTER_APP_SECRET=${TEST_RANDOM_STRING}" \
       --env="OAUTH_AUTHENTIQ_CLIENT_ID=${TEST_RANDOM_STRING}" \
       --env="OAUTH_AUTHENTIQ_CLIENT_SECRET=${TEST_RANDOM_STRING}" \
       --env="OAUTH_GITHUB_API_KEY=${TEST_RANDOM_STRING}" \
       --env="OAUTH_GITHUB_APP_SECRET=${TEST_RANDOM_STRING}" \
       --env="OAUTH_GITLAB_API_KEY=${TEST_RANDOM_STRING}" \
       --env="OAUTH_GITLAB_APP_SECRET=${TEST_RANDOM_STRING}" \
       --env="OAUTH_BITBUCKET_API_KEY=${TEST_RANDOM_STRING}" \
       --env="OAUTH_BITBUCKET_APP_SECRET=${TEST_RANDOM_STRING}" \
       --env="OAUTH_AUTH0_CLIENT_ID=${TEST_RANDOM_STRING}" \
       --env="OAUTH_AUTH0_CLIENT_SECRET=${TEST_RANDOM_STRING}" \
       --env="OAUTH_AUTH0_DOMAIN=example.com" \
       --env="OAUTH_AZURE_API_KEY=${TEST_RANDOM_STRING}" \
       --env="OAUTH_AZURE_API_SECRET=${TEST_RANDOM_STRING}" \
       --env="OAUTH_AZURE_TENANT_ID=${TEST_RANDOM_STRING}" \
       --env="GOOGLE_ANALYTICS_ID=UA-123-ab" \
       --env="GITALY_ENABLED=true" \
       --env="DB_ADAPTER=${DB_ADAPTER}" \
       --volume "${TEST_BASE_DIR}/logs:/var/log/gitlab" \
       ${REGISTRY_IMAGE}

RC=0

echo "Waiting for containers to start and settle, up to 10 minutes ..."
c=0
while [[ $(docker logs gitlab-test 2>&1 | grep -c "Recompiling assets") == 0 ]]; do
    echo "Still waiting ..."
    ((c++)) && ((c==20)) && echo "Timeout, exiting ..." && export RC=1 && break
    sleep 30
done

echo "Wait for gitlab to recompile assets, up to 10 minutes ..."
c=0
while [[ $(docker logs gitlab-test 2>&1 | tail -n 1 | grep -c "Recompiling assets") != 0 ]]; do
    echo "Still waiting ..."
    ((c++)) && ((c==20)) && echo "Timeout, exiting ..." && export RC=1 && break
    sleep 30
done

echo "Waiting for gitlab apps to start, up to 5 minutes ..."
c=0
while [[ $(docker logs gitlab-test 2>&1 | grep -c "INFO supervisord started with pid 1") == 0 ]]; do
    echo "Still waiting ..."
    ((c++)) && ((c==20)) && echo "Timeout, exiting ..." && export RC=1 && break
    sleep 30
done

echo "Allowing 60 seconds for supervisor to start other processes ..."
sleep 60

docker logs gitlab-test > "${TEST_BASE_DIR}/logs/docker-logs-gitlab.log" 2>&1
docker logs gitlab-redis > "${TEST_BASE_DIR}/logs/docker-logs-redis.log" 2>&1
docker logs "${DB_CONT}" > "${TEST_BASE_DIR}/logs/docker-logs-${DB_CONT}.log" 2>&1

mkdir -p "${TEST_BASE_DIR}/logs/gitlab-test-files/gl-config"
mkdir -p "${TEST_BASE_DIR}/logs/gitlab-test-files/gls-config"
mkdir -p "${TEST_BASE_DIR}/logs/gitlab-test-files/glm-config"
mkdir -p "${TEST_BASE_DIR}/logs/gitlab-test-files/supervisor"

docker cp -L gitlab-test:/home/git/gitlab/config "${TEST_BASE_DIR}/logs/gitlab-test-files/gl-config"
docker cp -L gitlab-test:/home/git/gitlab-shell/config.yml "${TEST_BASE_DIR}/logs/gitlab-test-files/gls-config"
docker cp -L gitlab-test:/home/git/gitlab-monitor/config "${TEST_BASE_DIR}/logs/gitlab-test-files/glm-config"
docker cp -L gitlab-test:/etc/supervisor "${TEST_BASE_DIR}/logs/gitlab-test-files/supervisor"

docker logs gitlab-test

if [[ $(docker logs gitlab-test 2>&1 | grep -i "error\|fail\|fatal" | grep -c -i -v "error_page\|error_log\|fail_timeout\|#") != 0 ]]; then
    export RC=1
    docker logs gitlab-test 2>&1 | grep -i "error\|fail\|fatal" | grep -i -v "error_page\|error_log\|fail_timeout\|#"
fi

docker exec gitlab-test sudo -HEu git bundle exec rake gitlab:env:info RAILS_ENV=production
docker exec gitlab-test sudo -HEu git bundle exec rake gitlab:check RAILS_ENV=production

echo "Stopping and removing containers ..."
docker stop gitlab-test gitlab-redis "${DB_CONT}"
docker rm -v -f gitlab-test gitlab-redis "${DB_CONT}"

if [[ $RC != 0 ]]; then
    exit $RC
else
    exit 0
fi
