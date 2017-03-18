#!/bin/bash
set -e

source ${GITLAB_RUNTIME_DIR}/functions

GITLAB_CLONE_URL=https://gitlab.com/gitlab-org/gitlab-ce.git
GITLAB_SHELL_CLONE_URL=https://gitlab.com/gitlab-org/gitlab-shell.git
GITLAB_WORKHORSE_CLONE_URL=https://gitlab.com/gitlab-org/gitlab-workhorse.git
GITLAB_PAGES_CLONE_URL=https://gitlab.com/gitlab-org/gitlab-pages.git
GITLAB_GITALY_CLONE_URL=https://gitlab.com/gitlab-org/gitaly.git
GITLAB_MONITOR_CLONE_URL=https://gitlab.com/gitlab-org/gitlab-monitor.git

GEM_CACHE_DIR="${GITLAB_BUILD_DIR}/cache"

BUILD_DEPENDENCIES="gcc g++ make patch pkg-config cmake paxctl \
  libc6-dev ruby${RUBY_VERSION}-dev libkrb5-dev \
  libpq-dev zlib1g-dev libyaml-dev libssl-dev \
  libgdbm-dev libreadline-dev libncurses5-dev libffi-dev \
  libxml2-dev libxslt-dev libcurl4-openssl-dev libicu-dev"

## Execute a command as GITLAB_USER
exec_as_git() {
  if [[ $(whoami) == ${GITLAB_USER} ]]; then
    $@
  else
    sudo -HEu ${GITLAB_USER} "$@"
  fi
}

# install build dependencies for gem installation
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y ${BUILD_DEPENDENCIES}

# https://en.wikibooks.org/wiki/Grsecurity/Application-specific_Settings#Node.js
paxctl -Cm `which nodejs`

# remove the host keys generated during openssh-server installation
rm -rf /etc/ssh/ssh_host_*_key /etc/ssh/ssh_host_*_key.pub

# add ${GITLAB_USER} user
adduser --disabled-login --gecos 'GitLab' ${GITLAB_USER}
passwd -d ${GITLAB_USER}

# set PATH (fixes cron job PATH issues)
cat >> ${GITLAB_HOME}/.profile <<EOF
PATH=\$HOME/.yarn/bin:/usr/local/sbin:/usr/local/bin:\$PATH
EOF

# download and install fresh yarn
curl -s --location https://yarnpkg.com/install.sh | exec_as_git bash - >/dev/null 2>&1

# configure git for ${GITLAB_USER}
exec_as_git git config --global core.autocrlf input
exec_as_git git config --global gc.auto 0
exec_as_git git config --global repack.writeBitmaps true

#
# Download necessary sources
#

# download gitlab-shell
echo "Cloning gitlab-shell v.${GITLAB_SHELL_VERSION}..."
exec_as_git git clone -q -b v${GITLAB_SHELL_VERSION} --depth 1 ${GITLAB_SHELL_CLONE_URL} ${GITLAB_SHELL_INSTALL_DIR}

# download gitlab-monitor
echo "Cloning gitlab-monitor v.${GITLAB_MONITOR_VERSION}..."
exec_as_git git clone -q -b v${GITLAB_MONITOR_VERSION} --depth 1 ${GITLAB_MONITOR_CLONE_URL} ${GITLAB_MONITOR_INSTALL_DIR}

# download gitaly
echo "Cloning gitlab-pages v.${GITLAB_GITALY_VERSION}..."
exec_as_git git clone -q -b v${GITLAB_GITALY_VERSION} --depth 1 ${GITLAB_GITALY_CLONE_URL} ${GITLAB_GITALY_INSTALL_DIR}

# download gitlab-workhose
echo "Cloning gitlab-workhorse v.${GITLAB_WORKHORSE_VERSION}..."
exec_as_git git clone -q -b v${GITLAB_WORKHORSE_VERSION} --depth 1 ${GITLAB_WORKHORSE_CLONE_URL} ${GITLAB_WORKHORSE_INSTALL_DIR}

# download pages
echo "Cloning gitlab-pages v.${GITLAB_PAGES_VERSION}..."
exec_as_git git clone -q -b v${GITLAB_PAGES_VERSION} --depth 1 ${GITLAB_PAGES_CLONE_URL} ${GITLAB_PAGES_INSTALL_DIR}

# download golang
echo "Downloading Go ${GOLANG_VERSION}..."
wget -cnv https://storage.googleapis.com/golang/go${GOLANG_VERSION}.linux-amd64.tar.gz -P ${GITLAB_BUILD_DIR}/
tar -xf ${GITLAB_BUILD_DIR}/go${GOLANG_VERSION}.linux-amd64.tar.gz -C /tmp/

#
# Build and Install downloaded sources
#

# install gitlab-shell
cd ${GITLAB_SHELL_INSTALL_DIR}
exec_as_git cp -a ${GITLAB_SHELL_INSTALL_DIR}/config.yml.example ${GITLAB_SHELL_INSTALL_DIR}/config.yml
exec_as_git ./bin/install

# install gitlab-monitor
cd ${GITLAB_MONITOR_INSTALL_DIR}
exec_as_git bundle install -j$(nproc) --deployment

# install gitaly
cd ${GITLAB_GITALY_INSTALL_DIR}
PATH=/tmp/go/bin:$PATH GOROOT=/tmp/go make install

# install gitlab-workhorse
cd ${GITLAB_WORKHORSE_INSTALL_DIR}
PATH=/tmp/go/bin:$PATH GOROOT=/tmp/go make install

# install gitlab-pages
cd ${GITLAB_PAGES_INSTALL_DIR}
GODIR=/tmp/go/src/gitlab.com/gitlab-org/gitlab-pages
mkdir -p "$(dirname "$GODIR")"
ln -sfv "$(pwd -P)" "$GODIR"
cd "$GODIR"
PATH=/tmp/go/bin:$PATH GOROOT=/tmp/go make gitlab-pages
mv gitlab-pages /usr/local/bin/

#
# Cleanup
#

# remove unused repositories directory created by gitlab-shell install
exec_as_git rm -rf ${GITLAB_HOME}/repositories

# remove golang archive and executable
rm -rf ${GITLAB_BUILD_DIR}/go${GOLANG_VERSION}.linux-amd64.tar.gz /tmp/go

#
# Download and Install Gitlab CE from source
#

# shallow clone gitlab-ce
echo "Cloning gitlab-ce v.${GITLAB_VERSION}..."
exec_as_git git clone -q -b v${GITLAB_VERSION} --depth 1 ${GITLAB_CLONE_URL} ${GITLAB_INSTALL_DIR}

# remove HSTS config from the default headers, we configure it in nginx
exec_as_git sed -i "/headers\['Strict-Transport-Security'\]/d" ${GITLAB_INSTALL_DIR}/app/controllers/application_controller.rb

# revert `rake gitlab:setup` changes from gitlabhq/gitlabhq@a54af831bae023770bf9b2633cc45ec0d5f5a66a
exec_as_git sed -i 's/db:reset/db:setup/' ${GITLAB_INSTALL_DIR}/lib/tasks/gitlab/setup.rake

cd ${GITLAB_INSTALL_DIR}

# check versions in the source, exit 1 if less then required
CACHE_GITALY_SERVER_VERSION=$(cat GITALY_SERVER_VERSION)
CACHE_GITLAB_PAGES_VERSION=$(cat GITLAB_PAGES_VERSION)
CACHE_GITLAB_SHELL_VERSION=$(cat GITLAB_SHELL_VERSION)
CACHE_GITLAB_WORKHORSE_VERSION=$(cat GITLAB_WORKHORSE_VERSION)

if [[ -n ${CACHE_GITLAB_SHELL_VERSION} && $(vercmp ${GITLAB_SHELL_VERSION} ${CACHE_GITLAB_SHELL_VERSION}) -lt 0 ]]; then
    echo "Gitlab Shell server version is less than required, installed ${GITLAB_SHELL_VERSION} ; required ${CACHE_GITLAB_SHELL_VERSION}"
    exit 1
fi

if [[ -n ${CACHE_GITLAB_WORKHORSE_VERSION} && $(vercmp ${GITLAB_WORKHORSE_VERSION} ${CACHE_GITLAB_WORKHORSE_VERSION}) -lt 0 ]]; then
    echo "Gitlab Workhorse server version is less than required, installed ${GITLAB_WORKHORSE_VERSION} ; required ${CACHE_GITLAB_WORKHORSE_VERSION}"
    exit 1
fi

if [[ -n ${CACHE_GITLAB_PAGES_VERSION} && $(vercmp ${GITLAB_PAGES_VERSION} ${CACHE_GITLAB_PAGES_VERSION}) -lt 0 ]]; then
    echo "Gitlab Pages server version is less than required, installed ${GITLAB_PAGES_VERSION} ; required ${CACHE_GITLAB_PAGES_VERSION}"
    exit 1
fi

if [[ -n ${CACHE_GITALY_SERVER_VERSION} && $(vercmp ${GITLAB_GITALY_VERSION} ${CACHE_GITALY_SERVER_VERSION}) -lt 0 ]]; then
    echo "Gitaly server version is less than required, installed ${GITLAB_GITALY_VERSION} ; required ${CACHE_GITALY_SERVER_VERSION}"
    exit 1
fi

# install gems, use local cache if available
if [[ -d ${GEM_CACHE_DIR} ]]; then
  mv ${GEM_CACHE_DIR} ${GITLAB_INSTALL_DIR}/vendor/cache
  chown -R ${GITLAB_USER}: ${GITLAB_INSTALL_DIR}/vendor/cache
fi
exec_as_git bundle install -j$(nproc) --deployment --without mysql development test aws

# make sure everything in ${GITLAB_HOME} is owned by ${GITLAB_USER} user
chown -R ${GITLAB_USER}: ${GITLAB_HOME}

# gitlab.yml and database.yml are required for `assets:precompile`
exec_as_git cp ${GITLAB_INSTALL_DIR}/config/gitlab.yml.example ${GITLAB_INSTALL_DIR}/config/gitlab.yml
exec_as_git cp ${GITLAB_INSTALL_DIR}/config/database.yml.postgresql ${GITLAB_INSTALL_DIR}/config/database.yml

echo "Compiling assets. Please be patient, this could take a while..."
# Compile assets
# Installs nodejs packages required to compile webpack
exec_as_git ${GITLAB_HOME}/.yarn/bin/yarn install --production --pure-lockfile

echo "Executing rake commands to clean and compile assets"
# Adding webpack compile needed since 8.17
exec_as_git bundle exec rake assets:clean assets:precompile webpack:compile USE_DB=false SKIP_STORAGE_VALIDATION=true RAILS_ENV=${RAILS_ENV} NODE_ENV=${RAILS_ENV}>/dev/null 2>&1

echo "remove auto generated ${GITLAB_DATA_DIR}/config/secrets.yml"
rm -rf ${GITLAB_DATA_DIR}/config/secrets.yml

exec_as_git mkdir -p ${GITLAB_INSTALL_DIR}/tmp/pids/ ${GITLAB_INSTALL_DIR}/tmp/sockets/private/
chmod -R u+rwX ${GITLAB_INSTALL_DIR}/tmp

# Make a private socket dir for gitaly
chmod 0700 ${GITLAB_INSTALL_DIR}/tmp/sockets/private

echo "symlink ${GITLAB_HOME}/.ssh -> ${GITLAB_LOG_DIR}/gitlab"
rm -rf ${GITLAB_HOME}/.ssh
exec_as_git ln -sf ${GITLAB_DATA_DIR}/.ssh ${GITLAB_HOME}/.ssh

echo "symlink ${GITLAB_INSTALL_DIR}/log -> ${GITLAB_LOG_DIR}/gitlab"
rm -rf ${GITLAB_INSTALL_DIR}/log
ln -sf ${GITLAB_LOG_DIR}/gitlab ${GITLAB_INSTALL_DIR}/log

echo "symlink ${GITLAB_INSTALL_DIR}/public/uploads -> ${GITLAB_DATA_DIR}/uploads"
rm -rf ${GITLAB_INSTALL_DIR}/public/uploads
exec_as_git ln -sf ${GITLAB_DATA_DIR}/uploads ${GITLAB_INSTALL_DIR}/public/uploads

echo "symlink ${GITLAB_INSTALL_DIR}/.secret -> ${GITLAB_DATA_DIR}/.secret"
rm -rf ${GITLAB_INSTALL_DIR}/.secret
exec_as_git ln -sf ${GITLAB_DATA_DIR}/.secret ${GITLAB_INSTALL_DIR}/.secret

# WORKAROUND for https://github.com/sameersbn/docker-gitlab/issues/509
rm -rf ${GITLAB_INSTALL_DIR}/builds
rm -rf ${GITLAB_INSTALL_DIR}/shared

echo "install gitlab bootscript, to silence gitlab:check warnings"
cp ${GITLAB_INSTALL_DIR}/lib/support/init.d/gitlab /etc/init.d/gitlab
chmod +x /etc/init.d/gitlab

# disable default nginx configuration and enable gitlab's nginx configuration
rm -rf /etc/nginx/sites-enabled/default

echo "Configuring SSHD"
# configure sshd
sed -i \
  -e "s|^[#]*UsePAM yes|UsePAM no|" \
  -e "s|^[#]*UsePrivilegeSeparation yes|UsePrivilegeSeparation no|" \
  -e "s|^[#]*PasswordAuthentication yes|PasswordAuthentication no|" \
  -e "s|^[#]*LogLevel INFO|LogLevel VERBOSE|" \
  /etc/ssh/sshd_config
echo "UseDNS no" >> /etc/ssh/sshd_config

echo "move supervisord.log file to ${GITLAB_LOG_DIR}/supervisor/"
sed -i "s|^[#]*logfile=.*|logfile=${GITLAB_LOG_DIR}/supervisor/supervisord.log ;|" /etc/supervisor/supervisord.conf

echo "move nginx logs to ${GITLAB_LOG_DIR}/nginx"
sed -i \
  -e "s|access_log /var/log/nginx/access.log;|access_log ${GITLAB_LOG_DIR}/nginx/access.log;|" \
  -e "s|error_log /var/log/nginx/error.log;|error_log ${GITLAB_LOG_DIR}/nginx/error.log;|" \
  /etc/nginx/nginx.conf

echo "Configuring log rotations"
# configure supervisord log rotation
cat > /etc/logrotate.d/supervisord <<EOF
${GITLAB_LOG_DIR}/supervisor/*.log {
  weekly
  missingok
  rotate 52
  compress
  delaycompress
  notifempty
  copytruncate
}
EOF

# configure gitlab log rotation
cat > /etc/logrotate.d/gitlab <<EOF
${GITLAB_LOG_DIR}/gitlab/*.log {
  weekly
  missingok
  rotate 52
  compress
  delaycompress
  notifempty
  copytruncate
}
EOF

# configure gitlab-shell log rotation
cat > /etc/logrotate.d/gitlab-shell <<EOF
${GITLAB_LOG_DIR}/gitlab-shell/*.log {
  weekly
  missingok
  rotate 52
  compress
  delaycompress
  notifempty
  copytruncate
}
EOF

# configure gitlab vhost log rotation
cat > /etc/logrotate.d/gitlab-nginx <<EOF
${GITLAB_LOG_DIR}/nginx/*.log {
  weekly
  missingok
  rotate 52
  compress
  delaycompress
  notifempty
  copytruncate
}
EOF

echo "Configuring supervisord scripts"
# configure supervisord to start unicorn
cat > /etc/supervisor/conf.d/unicorn.conf <<EOF
[program:unicorn]
priority=10
directory=${GITLAB_INSTALL_DIR}
environment=HOME=${GITLAB_HOME}
command=bundle exec unicorn_rails -c ${GITLAB_INSTALL_DIR}/config/unicorn.rb -E ${RAILS_ENV}
user=git
autostart=true
autorestart=true
stopsignal=QUIT
stdout_logfile=${GITLAB_LOG_DIR}/supervisor/%(program_name)s.log
stderr_logfile=${GITLAB_LOG_DIR}/supervisor/%(program_name)s.log
EOF

# configure supervisord to start sidekiq
cat > /etc/supervisor/conf.d/sidekiq.conf <<EOF
[program:sidekiq]
priority=10
directory=${GITLAB_INSTALL_DIR}
environment=HOME=${GITLAB_HOME}
command=bundle exec sidekiq -c {{SIDEKIQ_CONCURRENCY}}
  -C ${GITLAB_INSTALL_DIR}/config/sidekiq_queues.yml
  -e ${RAILS_ENV}
  -t {{SIDEKIQ_SHUTDOWN_TIMEOUT}}
  -P ${GITLAB_INSTALL_DIR}/tmp/pids/sidekiq.pid
  -L ${GITLAB_INSTALL_DIR}/log/sidekiq.log
user=git
autostart=true
autorestart=true
stdout_logfile=${GITLAB_LOG_DIR}/supervisor/%(program_name)s.log
stderr_logfile=${GITLAB_LOG_DIR}/supervisor/%(program_name)s.log
EOF

# configure supervisord to start gitlab-workhorse
cat > /etc/supervisor/conf.d/gitlab-workhorse.conf <<EOF
[program:gitlab-workhorse]
priority=20
directory=${GITLAB_INSTALL_DIR}
environment=HOME=${GITLAB_HOME}
command=/usr/local/bin/gitlab-workhorse
  -listenUmask 0
  -listenNetwork tcp
  -listenAddr ":{{GITLAB_WORKHORSE_PORT}}"
  -authBackend http://127.0.0.1:8080{{GITLAB_RELATIVE_URL_ROOT}}
  -authSocket ${GITLAB_INSTALL_DIR}/tmp/sockets/gitlab.socket
  -documentRoot ${GITLAB_INSTALL_DIR}/public
  -proxyHeadersTimeout {{GITLAB_WORKHORSE_TIMEOUT}}
user=git
autostart=true
autorestart=true
stdout_logfile=${GITLAB_INSTALL_DIR}/log/%(program_name)s.log
stderr_logfile=${GITLAB_INSTALL_DIR}/log/%(program_name)s.log
EOF

# configure supervisord to start gitlab-pages
cat > /etc/supervisor/conf.d/gitlab-pages.conf <<EOF
[program:gitlab-pages]
priority=20
directory=${GITLAB_INSTALL_DIR}
environment=HOME=${GITLAB_HOME}
command=/usr/local/bin/gitlab-pages
  -pages-domain {{GITLAB_PAGES_DOMAIN}}
  -pages-root {{GITLAB_PAGES_DIR}}
  -listen-proxy :{{GITLAB_PAGES_PORT}}
  -metrics-address :{{GITLAB_PAGES_METRICS_PORT}}
  -daemon-uid {{GITLAB_UID}}
  -daemon-gid {{GITLAB_GID}}
user=root
autostart={{GITLAB_PAGES_ENABLED}}
autorestart=true
stdout_logfile=${GITLAB_INSTALL_DIR}/log/%(program_name)s.log
stderr_logfile=${GITLAB_INSTALL_DIR}/log/%(program_name)s.log
EOF

# configure supervisord to start gitlab-monitor
cat > /etc/supervisor/conf.d/gitlab-monitor.conf <<EOF
[program:gitlab-monitor]
priority=30
directory=${GITLAB_MONITOR_INSTALL_DIR}
environment=HOME=${GITLAB_HOME}
command=bundle exec ${GITLAB_MONITOR_INSTALL_DIR}/bin/gitlab-mon web -c ${GITLAB_MONITOR_INSTALL_DIR}/config/gitlab-monitor.yml
user=git
autostart={{GITLAB_MONITOR_ENABLED}}
autorestart=true
stdout_logfile=${GITLAB_INSTALL_DIR}/log/%(program_name)s.log
stderr_logfile=${GITLAB_INSTALL_DIR}/log/%(program_name)s.log
EOF

# configure supervisord to start mail_room
cat > /etc/supervisor/conf.d/mail_room.conf <<EOF
[program:mail_room]
priority=20
directory=${GITLAB_INSTALL_DIR}
environment=HOME=${GITLAB_HOME}
command=bundle exec mail_room -c ${GITLAB_INSTALL_DIR}/config/mail_room.yml
user=git
autostart={{GITLAB_INCOMING_EMAIL_ENABLED}}
autorestart=true
stdout_logfile=${GITLAB_INSTALL_DIR}/log/%(program_name)s.log
stderr_logfile=${GITLAB_INSTALL_DIR}/log/%(program_name)s.log
EOF

# configure supervisor to start sshd
mkdir -p /var/run/sshd
cat > /etc/supervisor/conf.d/sshd.conf <<EOF
[program:sshd]
directory=/
command=/usr/sbin/sshd -D -E ${GITLAB_LOG_DIR}/supervisor/%(program_name)s.log
user=root
autostart=true
autorestart=true
stdout_logfile=${GITLAB_LOG_DIR}/supervisor/%(program_name)s.log
stderr_logfile=${GITLAB_LOG_DIR}/supervisor/%(program_name)s.log
EOF

# configure supervisord to start nginx
cat > /etc/supervisor/conf.d/nginx.conf <<EOF
[program:nginx]
priority=20
directory=/tmp
command=/usr/sbin/nginx -g "daemon off;"
user=root
autostart=true
autorestart=true
stdout_logfile=${GITLAB_LOG_DIR}/supervisor/%(program_name)s.log
stderr_logfile=${GITLAB_LOG_DIR}/supervisor/%(program_name)s.log
EOF

# configure supervisord to start crond
cat > /etc/supervisor/conf.d/cron.conf <<EOF
[program:cron]
priority=20
directory=/tmp
command=/usr/sbin/cron -f
user=root
autostart=true
autorestart=true
stdout_logfile=${GITLAB_LOG_DIR}/supervisor/%(program_name)s.log
stderr_logfile=${GITLAB_LOG_DIR}/supervisor/%(program_name)s.log
EOF

echo "Cleaning-up ..."
# purge build dependencies and cleanup apt
apt-get purge -y --auto-remove ${BUILD_DEPENDENCIES}
rm -rf /var/lib/apt/lists/*
