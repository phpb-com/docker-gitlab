[![build status](https://gotfix.com/docker/gitlab/badges/master/build.svg)](https://gotfix.com/docker/gitlab/commits/master) [![Docker Repository on Quay](https://quay.io/repository/gotfix/gitlab/status "Docker Repository on Quay")](https://quay.io/repository/gotfix/gitlab) [![](https://images.microbadger.com/badges/image/gotfix/gitlab.svg)](https://microbadger.com/images/gotfix/gitlab "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/gotfix/gitlab.svg)](https://microbadger.com/images/gotfix/gitlab "Get your own version badge on microbadger.com") [![Docker Pulls](https://img.shields.io/docker/pulls/gotfix/gitlab.svg)](https://hub.docker.com/r/gotfix/gitlab/)

# gotfix/gitlab:9.3.7

> Alternatively image is available from quay.io `quay.io/gotfix/gitlab:9.3.7`

# Canonical source

The canonical source of the repository is [hosted on gotfix.com](https://gotfix.com/docker/gitlab).


-------


# Table of Content

- [Introduction](#introduction)
  * [Contributing](#contributing)
  * [Team](#team)
  * [Issues](#issues)
- [Installation](#installation)
  * [Prerequisites](#prerequisites)
  * [Preparing container image](#preparing-container-image)
  * [Quick Start](#quick-start)
  * [Configuration](#configuration)
    + [Caddy (front-end web-server)](#caddy-front-end-web-server)
    + [Data Store](#data-store)
    + [Database](#database)
      - [PostgreSQL](#postgresql)
        * [External PostgreSQL Server](#external-postgresql-server)
        * [Linking to PostgreSQL Container](#linking-to-postgresql-container)
      - [MySQL](#mysql)
        * [External MySQL Server](#external-mysql-server)
        * [Linking to MySQL Container](#linking-to-mysql-container)
    + [Redis](#redis)
      - [External Redis Server](#external-redis-server)
      - [Linking to Redis Container](#linking-to-redis-container)
    + [Mail](#mail)
      - [Reply by email](#reply-by-email)
    + [Enabling HTTPS support](#enabling-https-support)
      - [Using HTTPS with a load balancer](#using-https-with-a-load-balancer)
      - [Installing Trusted SSL Server Certificates](#installing-trusted-ssl-server-certificates)
    + [Deploy to a subdirectory (relative url root)](#deploy-to-a-subdirectory-relative-url-root)
    + [OmniAuth Integration](#omniauth-integration)
      - [CAS3](#cas3)
      - [Authentiq](#authentiq)
      - [Google](#google)
      - [Facebook](#facebook)
      - [Twitter](#twitter)
      - [GitHub](#github)
      - [GitLab](#gitlab)
      - [BitBucket](#bitbucket)
      - [SAML](#saml)
      - [Crowd](#crowd)
      - [Auth0](#auth0)
      - [Microsoft Azure](#microsoft-azure)
    + [Host UID / GID Mapping](#host-uid--gid-mapping)
    + [Piwik](#piwik)
    + [Grafana](#grafana)
      - [Setup Grafana dashboard for GitLab](#setup-grafana-dashboard-for-gitlab)
      - [GitLab settings to enable metrics agent for Prometheus](#gitlab-settings-to-enable-metrics-agent-for-prometheus)
    + [Available Configuration Parameters](#available-configuration-parameters)
- [Maintenance](#maintenance)
- [FAQ](#faq)
  * [Why did you fork instead of contributing to the original project?](#why-did-you-fork-instead-of-contributing-to-the-original-project)
  * [Why NGINX is removed from the image?](#why-nginx-is-removed-from-the-image)
  * [Why are you not hosting this project on GitHub and only maintaining mirror there?](#why-are-you-not-hosting-this-project-on-github-and-only-maintaining-mirror-there)
  * [I would like to help, what should I do?](#i-would-like-to-help-what-should-i-do)
  * [Why are you not supporting feature X?](#why-are-you-not-supporting-feature-x)
  * [Where are the Kubernetes configuration files?](#where-are-the-kubernetes-configuration-files)
- [References](#references)


**Other References**

- [Originally forked from sameersbn/docker-gitlab](https://github.com/sameersbn/docker-gitlab).
- [GitLab Container Registry](https://gotfix.com/docker/gitlab/blob/master/docs/container_registry.md)
- [Reuse docker host SSH daemon](https://gotfix.com/docker/gitlab/blob/master/docs/docker_host_ssh.md)
- [GitLab Backup to s3 compatible storage](https://gotfix.com/docker/gitlab/blob/master/docs/s3_compatible_storage.md)
- [Complete list of Configuration Parameters](https://gotfix.com/docker/gitlab/blob/master/docs/configuration_parameters.md)
- [Maintenance Commands](https://gotfix.com/docker/gitlab/blob/master/docs/maintenance.md)
- [Caddy for GitLab](https://gotfix.com/docker/caddy)
- [Setup of GitLab Docker on Synology DSM](https://github.com/cpoetter/Synology-GitLab-Setup) - Courtesy of [cpoetter@](https://github.com/cpoetter)

# Introduction

Dockerfile to build a [GitLab](https://about.gitlab.com/) image for the [Docker](https://www.docker.com/products/docker-engine) opensource container platform.

GitLab CE is set up in the Docker image using the [install from source](https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/install/installation.md) method as documented in the official GitLab documentation.

For other methods to install GitLab please refer to the [Official GitLab Installation Guide](https://about.gitlab.com/installation/) which includes a [GitLab image for Docker](https://gitlab.com/gitlab-org/gitlab-ce/tree/master/docker).

## Contributing

If you find this image useful here's how you can help:

- Send a Pull Request with your awesome new features and bug fixes
- Be a part of the community and help resolve [Issues](https://gotfix.com/docker/gitlab/issues)

## Team

- Ian Matyssik ([matyssik](https://gotfix.com/matyssik))

See [Contributors](https://gotfix.com/docker/gitlab/graphs/master) for the complete list developers that have contributed to this project.

## Issues

Docker is a relatively new project and is active being developed and tested by a thriving community of developers and testers and every release of docker features many enhancements and bugfixes.

Given the nature of the development and release cycle it is very important that you have the latest version of docker installed because any issue that you encounter might have already been fixed with a newer docker release.

Install the most recent version of the Docker Engine for your platform using the [official Docker releases](http://docs.docker.com/engine/installation/), which can also be installed using:

```bash
wget -qO- https://get.docker.com/ | sh
```

Fedora and RHEL/CentOS users should try disabling selinux with `setenforce 0` and check if resolves the issue. If it does than there is not much that I can help you with. You can either stick with selinux disabled (not recommended by redhat) or switch to using ubuntu.

You may also set `DEBUG=true` to enable debugging of the entrypoint script, which could help you pin point any configuration issues.

If using the latest docker version and/or disabling selinux does not fix the issue then please file an issue request on the [**issues**](https://gotfix.com/docker/gitlab/issues) page.

In your issue report please make sure you provide the following information:

- The host distribution and release version.
- Output of the `docker version` command
- Output of the `docker info` command
- The `docker run` command you used to run the image (mask out the sensitive bits).

# Installation

## Prerequisites

Your docker host needs to have 2GB or more of available RAM to run GitLab. Please refer to the GitLab [hardware requirements](https://github.com/gitlabhq/gitlabhq/blob/master/doc/install/requirements.md#hardware-requirements) documentation for additional information. Note that those requirements might be outdated and not always based on the real data, so take precautions. It is always safer to slightly over provision capacity than have less than required.

## Preparing container image

Automated builds of the image are available from [Dockerhub](https://hub.docker.com/r/gotfix/gitlab) and is the recommended method of installation.

```bash
docker pull gotfix/gitlab:9.3.7
```

You can also pull the `latest` tag which is built from the repository *HEAD*

```bash
docker pull gotfix/gitlab:latest
```

Alternatively you can build the image locally.

```bash
docker build -t gotfix/gitlab gotfix.com/docker/gitlab
```

## Quick Start

The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/).

```bash
wget https://gotfix.com/docker/gitlab/raw/master/docker-compose.yml
```

Generate random strings that are at least `64` characters long for each of `GITLAB_SECRETS_OTP_KEY_BASE`, `GITLAB_SECRETS_DB_KEY_BASE`, and `GITLAB_SECRETS_SECRET_KEY_BASE`. These values are used for the following:

- `GITLAB_SECRETS_OTP_KEY_BASE` is used to encrypt 2FA secrets in the database. If you lose or rotate this secret, none of your users will be able to log in using 2FA.
- `GITLAB_SECRETS_DB_KEY_BASE` is used to encrypt CI secret variables, as well as import credentials, in the database. If you lose or rotate this secret, you will not be able to use existing CI secrets.
- `GITLAB_SECRETS_SECRET_KEY_BASE` is used for password reset links, and other 'standard' auth features. If you lose or rotate this secret, password reset tokens in emails will reset.

> **Tip**: You can generate a random string using `pwgen -Bsv1 64` and assign it as the value of `GITLAB_SECRETS_DB_KEY_BASE`.

Start GitLab using:

```bash
docker-compose up
```

Alternatively, you can manually launch the `gitlab` container and the supporting `postgresql` and `redis` containers by following this three step guide.

Step 1. Launch a postgresql container

```bash
docker run --name gitlab-postgresql -d \
    --env 'DB_NAME=gitlabhq_production' \
    --env 'DB_USER=gitlab' --env 'DB_PASS=password' \
    --env 'DB_EXTENSION=pg_trgm' \
    --volume /srv/docker/gitlab/postgresql:/var/lib/postgresql \
    gotfix/postgresql:latest
```

Step 2. Launch a redis container

```bash
docker run --name gitlab-redis -d \
    --volume /srv/docker/gitlab/redis:/var/lib/redis \
    gotfix/redis:latest
```

Step 3. Launch the gitlab container

```bash
docker run --name gitlab -d \
    --link gitlab-postgresql:postgresql --link gitlab-redis:redisio \
    --publish 10022:22 --publish 10080:8181 \
    --env 'GITLAB_PORT=10080' --env 'GITLAB_SSH_PORT=10022' \
    --env 'GITLAB_SECRETS_DB_KEY_BASE=long-and-random-alpha-numeric-string' \
    --env 'GITLAB_SECRETS_SECRET_KEY_BASE=long-and-random-alpha-numeric-string' \
    --env 'GITLAB_SECRETS_OTP_KEY_BASE=long-and-random-alpha-numeric-string' \
    --volume /srv/docker/gitlab/gitlab:/home/git/data \
    gotfix/gitlab:9.3.7
```

*Please refer to [Available Configuration Parameters](#available-configuration-parameters) to understand `GITLAB_PORT` and other configuration options*

__NOTE__: Please allow a couple of minutes for the GitLab application to start.

Point your browser to `http://localhost:10080` and set a password for the `root` user account.

You should now have the GitLab application up and ready for testing. If you want to use this image in production then please read on.

*The rest of the document will use the docker command line. You can quite simply adapt your configuration into a `docker-compose.yml` file if you wish to do so.*

## Configuration

### Caddy (front-end web-server)

GitLab uses gitlab-workhorse to accept HTTP connection, and it is expecting to receive those connections via reveres-proxy, such as Caddy (or nginx). Since NGINX is no longer present in this container image, we will use [Caddy for GitLab](https://gotfix.com/docker/caddy) to handle those. For a complete list of configuration parameters, you should read [here](https://gotfix.com/docker/caddy/blob/master/README.md). In this section we will only cover minimum steps to get you started.

If you are using plain docker (not docker-compose), the follwoing `--env` settings will be required to run GitLab (similar setting are available for Pages and Registry):
```bash
$ docker run -d \
    --link=gitlab:gitlab \
    --env="GITLAB_HOST=gitlab.example.com" \
    --env="TLS_AGREE=true" \
    --env="CADDY_EMAIL=admin@example.com" \
    -v $HOME/.caddy:/root/.caddy \
    -v $HOME/caddy/logs:/var/log/caddy \
    -p 80:80 -p 443:443 \
    gotfix/caddy:latest-gitlab
```

For docker-compose, you will have to configure something similar to the following:
```yaml
  caddy:
    restart: always
    image: gotfix/caddy:latest-gitlab
    depends_on:
    - gitlab # Ensures that caddy will relink if gitlab container is restarted
    command:
    - -quic
    ports:
    - 80:80
    - 443:443
    environment:
    - TLS_AGREE=true # Indicates that you have read and agree to the Let's Encrypt Subscriber Agreement.
    - CADDY_EMAIL=admin@example.com # Make sure this email is yours and reachable
    - GITLAB_HOST=gitlab.example.com # Hostname of the GitLab installation that this server is reachable at
    - GITLAB_IP=gitlab # IP/Hostname of the running Gitlab service. This assume that Gitlab is configured in the same `services:` section under name gitlab.
    volumes:
    - ./.caddy:/root/.caddy # Your certificates will be stored here
    - ./gitlab/caddy/logs:/var/log/caddy:Z # Caddy logs will be stored here
```
See [example gitlab docker-compose](https://gotfix.com/docker/caddy/blob/master/gitlab/docker-compose.yml) for a more complete file.

### Data Store

GitLab is a code hosting software and as such you don't want to lose your code when the docker container is stopped/deleted. To avoid losing any data, you should mount a volume at,

* `/home/git/data`

Note that if you are using the `docker-compose` approach, this has already been done for you.

SELinux users are also required to change the security context of the mount point so that it plays nicely with selinux.

```bash
mkdir -p /srv/docker/gitlab/gitlab
sudo chcon -Rt svirt_sandbox_file_t /srv/docker/gitlab/gitlab
```

Volumes can be mounted in docker by specifying the `-v` option in the docker run command.

```bash
docker run --name gitlab -d \
    --volume /srv/docker/gitlab/gitlab:/home/git/data \
    gotfix/gitlab:9.3.7
```

### Database

GitLab uses a database backend to store its data. You can configure this image to use either MySQL or PostgreSQL.

*Note: GitLab HQ recommends using PostgreSQL over MySQL*

#### PostgreSQL

##### External PostgreSQL Server

The image also supports using an external PostgreSQL Server. This is also controlled via environment variables.

```sql
CREATE ROLE gitlab with LOGIN CREATEDB PASSWORD 'password';
CREATE DATABASE gitlabhq_production;
GRANT ALL PRIVILEGES ON DATABASE gitlabhq_production to gitlab;
```

Additionally since GitLab `8.6.0` the `pg_trgm` extension should also be loaded for the `gitlabhq_production` database.

We are now ready to start the GitLab application.

*Assuming that the PostgreSQL server host is 192.168.1.100*

```bash
docker run --name gitlab -d \
    --env 'DB_ADAPTER=postgresql' --env 'DB_HOST=192.168.1.100' \
    --env 'DB_NAME=gitlabhq_production' \
    --env 'DB_USER=gitlab' --env 'DB_PASS=password' \
    --volume /srv/docker/gitlab/gitlab:/home/git/data \
    gotfix/gitlab:9.3.7
```

##### Linking to PostgreSQL Container

You can link this image with a postgresql container for the database requirements. The alias of the postgresql server container should be set to **postgresql** while linking with the gitlab image.

If a postgresql container is linked, only the `DB_ADAPTER`, `DB_HOST` and `DB_PORT` settings are automatically retrieved using the linkage. You may still need to set other database connection parameters such as the `DB_NAME`, `DB_USER`, `DB_PASS` and so on.

To illustrate linking with a postgresql container, we will use the [gotfix/postgresql](https://gotfix.com/docker/postgresql) image. When using postgresql image in production you should mount a volume for the postgresql data store. Please refer the [README](https://gotfix.com/docker/postgresql/blob/master/README.md) of docker-postgresql for details.

First, lets pull the postgresql image from the docker index.

```bash
docker pull gotfix/postgresql:latest
```

For data persistence lets create a store for the postgresql and start the container.

SELinux users are also required to change the security context of the mount point so that it plays nicely with selinux.

```bash
mkdir -p /srv/docker/gitlab/postgresql
sudo chcon -Rt svirt_sandbox_file_t /srv/docker/gitlab/postgresql
```

The run command looks like this.

```bash
docker run --name gitlab-postgresql -d \
    --env 'DB_NAME=gitlabhq_production' \
    --env 'DB_USER=gitlab' --env 'DB_PASS=password' \
    --env 'DB_EXTENSION=pg_trgm' \
    --volume /srv/docker/gitlab/postgresql:/var/lib/postgresql \
    gotfix/postgresql:latest
```

The above command will create a database named `gitlabhq_production` and also create a user named `gitlab` with the password `password` with access to the `gitlabhq_production` database.

We are now ready to start the GitLab application.

```bash
docker run --name gitlab -d --link gitlab-postgresql:postgresql \
    --volume /srv/docker/gitlab/gitlab:/home/git/data \
    gotfix/gitlab:9.3.7
```

Here the image will also automatically fetch the `DB_NAME`, `DB_USER` and `DB_PASS` variables from the postgresql container as they are specified in the `docker run` command for the postgresql container. This is made possible using the magic of docker links and works with the following images:

 - [postgres](https://hub.docker.com/_/postgres/)
 - [gotfix/postgresql](https://hub.docker.com/r/gotfix/postgresql/)

#### MySQL

> Please read [this document](https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/install/database_mysql.md) to understand complexity involved with MySQL and Gitlab. You might need to take some of the manual steps to have installation or upgrade work correctly. Also see docker/gitlab#81 for what support is implemented.

##### External MySQL Server

The image can be configured to use an external MySQL database. The database configuration should be specified using environment variables while starting the GitLab image.

Before you start the GitLab image create user and database for gitlab.

```sql
CREATE USER 'gitlab'@'%.%.%.%' IDENTIFIED BY 'password';
CREATE DATABASE IF NOT EXISTS `gitlabhq_production` DEFAULT CHARACTER SET `utf8` COLLATE `utf8_unicode_ci`;
GRANT ALL PRIVILEGES ON `gitlabhq_production`.* TO 'gitlab'@'%.%.%.%';
```

We are now ready to start the GitLab application.

*Assuming that the mysql server host is 192.168.1.100*

```bash
docker run --name gitlab -d \
    --env 'DB_ADAPTER=mysql2' --env 'DB_HOST=192.168.1.100' \
    --env 'DB_NAME=gitlabhq_production' \
    --env 'DB_USER=gitlab' --env 'DB_PASS=password' \
    --volume /srv/docker/gitlab/gitlab:/home/git/data \
    gotfix/gitlab:9.3.7
```

##### Linking to MySQL Container

You can link this image with a mysql container for the database requirements. The alias of the mysql server container should be set to **mysql** while linking with the gitlab image.

If a mysql container is linked, only the `DB_ADAPTER`, `DB_HOST` and `DB_PORT` settings are automatically retrieved using the linkage. You may still need to set other database connection parameters such as the `DB_NAME`, `DB_USER`, `DB_PASS` and so on.

To illustrate linking with a mysql container, we will use the [MariaDB](https://hub.docker.com/_/mariadb/) image. When using docker-mysql in production you should mount a volume for the mysql data store.

First, lets pull the mysql image from the docker index.

```bash
docker pull mariadb:latest
```

For data persistence lets create a store for the mysql and start the container.

SELinux users are also required to change the security context of the mount point so that it plays nicely with selinux.

```bash
mkdir -p /srv/docker/gitlab/mysql
sudo chcon -Rt svirt_sandbox_file_t /srv/docker/gitlab/mysql
```

The run command looks like this.

```bash
docker run --name gitlab-mysql \
    --volume /srv/docker/gitlab/mysql:/var/lib/mysql \
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
```

The above command will create a database named `gitlabhq_production` and also create a user named `gitlab` with the password `password` with full/remote access to the `gitlabhq_production` database.

We are now ready to start the GitLab application.

```bash
docker run --name gitlab -d --link gitlab-mysql:mysql \
    --volume /srv/docker/gitlab/gitlab:/home/git/data \
    gotfix/gitlab:9.3.7
```

### Redis

GitLab uses the redis server for its key-value data store. The redis server connection details can be specified using environment variables.

#### External Redis Server

The image can be configured to use an external redis server. The configuration should be specified using environment variables while starting the GitLab image.

*Assuming that the redis server host is 192.168.1.100*

```bash
docker run --name gitlab -it --rm \
    --env 'REDIS_HOST=192.168.1.100' --env 'REDIS_PORT=6379' \
    gotfix/gitlab:9.3.7
```

#### Linking to Redis Container

You can link this image with a redis container to satisfy gitlab's redis requirement. The alias of the redis server container should be set to **redisio** while linking with the gitlab image.

To illustrate linking with a redis container, we will use the [gotfix/redis](https://gotfix.com/docker/redis) image. Please refer the [README](https://gotfix.com/docker/redis/blob/master/README.md) of docker-redis for details.

First, lets pull the redis image from the docker index.

```bash
docker pull gotfix/redis:latest
```

Lets start the redis container

```bash
docker run --name gitlab-redis -d \
    --volume /srv/docker/gitlab/redis:/var/lib/redis \
    gotfix/redis:latest
```

We are now ready to start the GitLab application.

```bash
docker run --name gitlab -d --link gitlab-redis:redisio \
    gotfix/gitlab:9.3.7
```

### Mail

The mail configuration should be specified using environment variables while starting the GitLab image. The configuration defaults to using gmail to send emails and requires the specification of a valid username and password to login to the gmail servers.

If you are using Gmail then all you need to do is:

```bash
docker run --name gitlab -d \
    --env 'SMTP_USER=USER@gmail.com' --env 'SMTP_PASS=PASSWORD' \
    --volume /srv/docker/gitlab/gitlab:/home/git/data \
    gotfix/gitlab:9.3.7
```

Please refer the [Available Configuration Parameters](#available-configuration-parameters) section for the list of SMTP parameters that can be specified.

#### Reply by email

Since version `8.0.0` GitLab adds support for commenting on issues by replying to emails.

To enable this feature you need to provide IMAP configuration parameters that will allow GitLab to connect to your mail server and read mails. Additionally, you may need to specify `GITLAB_INCOMING_EMAIL_ADDRESS` if your incoming email address is not the same as the `IMAP_USER`.

If your email provider supports email [sub-addressing](https://en.wikipedia.org/wiki/Email_address#Sub-addressing) then you should add the `+%{key}` placeholder after the user part of the email address, eg. `GITLAB_INCOMING_EMAIL_ADDRESS=reply+%{key}@example.com`. Please read the [documentation on reply by email](http://doc.gitlab.com/ce/incoming_email/README.html) to understand the requirements for this feature.

If you are using Gmail then all you need to do is:

```bash
docker run --name gitlab -d \
    --env 'IMAP_USER=USER@gmail.com' --env 'IMAP_PASS=PASSWORD' \
    --env 'GITLAB_INCOMING_EMAIL_ADDRESS=USER+%{key}@gmail.com' \
    --volume /srv/docker/gitlab/gitlab:/home/git/data \
    gotfix/gitlab:9.3.7
```

Please refer the [Available Configuration Parameters](#available-configuration-parameters) section for the list of IMAP parameters that can be specified.

### Enabling HTTPS support

HTTPS support can be enabled by setting the `GITLAB_HTTPS` option to `true`.

```bash
docker run --name gitlab -d \
    --publish 10022:22 --publish 10080:8181 \
    --env 'GITLAB_SSH_PORT=10022' --env 'GITLAB_PORT=443' \
    --env 'GITLAB_HTTPS=true' \
    --volume /srv/docker/gitlab/gitlab:/home/git/data \
    gotfix/gitlab:9.3.7
```

In this configuration, any requests made over the plain http protocol will automatically be redirected to use the https protocol.

#### Using HTTPS with a load balancer

Load balancers like nginx/haproxy/hipache talk to backend applications over plain http and as such the installation of ssl keys and certificates are not required and should **NOT** be installed in the container. The SSL configuration has to instead be done at the load balancer.

However, when using a load balancer you **MUST** set `GITLAB_HTTPS` to `true`.

With this in place, you should configure the load balancer to support handling of https requests. But that is out of the scope of this document. Please refer to [Using SSL/HTTPS with HAProxy](http://seanmcgary.com/posts/using-sslhttps-with-haproxy) for information on the subject.

When using a load balancer, you probably want to make sure the load balancer performs the automatic http to https redirection. Information on this can also be found in the link above.

In summation, when using a load balancer, the docker command would look for the most part something like this:

```bash
docker run --name gitlab -d \
    --publish 10022:22 --publish 10080:8181 \
    --env 'GITLAB_SSH_PORT=10022' --env 'GITLAB_PORT=443' \
    --env 'GITLAB_HTTPS=true' \
    --volume /srv/docker/gitlab/gitlab:/home/git/data \
    gotfix/gitlab:9.3.7
```

In case GitLab responds to any kind of POST request (login, OAUTH, changing settings etc.) with a 422 HTTP Error, consider adding this to your reverse proxy configuration:

`proxy_set_header X-Forwarded-Ssl on;` (nginx format)

#### Installing Trusted SSL Server Certificates

If any of the services that your GitLab server is accessing are using self-signed SSL certificates then you should make sure their server certificate are trusted on the GitLab server for them to be able to talk to each other.

The default path image is configured to look for the trusted SSL certificates is at `/home/git/data/certs/ca.crt`, this can however be changed using the `SSL_CA_CERTIFICATES_PATH` configuration option.

Copy the `ca.crt` file into the certs directory on the [datastore](#data-store). The `ca.crt` file should contain the root certificates of all the servers you want to trust.

By default, our own server certificate [gitlab.crt](#generation-of-self-signed-certificate) is added to the trusted certificates list.

### Deploy to a subdirectory (relative url root)

By default GitLab expects that your application is running at the root (eg. /). This section explains how to run your application inside a directory.

Let's assume we want to deploy our application to '/git'. GitLab needs to know this directory to generate the appropriate routes. This can be specified using the `GITLAB_RELATIVE_URL_ROOT` configuration option like so:

```bash
docker run --name gitlab -it --rm \
    --env 'GITLAB_RELATIVE_URL_ROOT=/git' \
    --volume /srv/docker/gitlab/gitlab:/home/git/data \
    gotfix/gitlab:9.3.7
```

GitLab will now be accessible at the `/git` path, e.g., `http://www.example.com/git`.

**Note**: *The `GITLAB_RELATIVE_URL_ROOT` parameter should always begin with a slash and* **SHOULD NOT** *have any trailing slashes.*

### OmniAuth Integration

GitLab leverages OmniAuth to allow users to sign in using Twitter, GitHub, and other popular services. Configuring OmniAuth does not prevent standard GitLab authentication or LDAP (if configured) from continuing to work. Users can choose to sign in using any of the configured mechanisms.

Refer to the GitLab [documentation](http://doc.gitlab.com/ce/integration/omniauth.html) for additional information.

#### CAS3

To enable the CAS OmniAuth provider you must register your application with your CAS instance. This requires the service URL GitLab will supply to CAS. It should be something like: https://git.example.com:443/users/auth/cas3/callback?url. By default handling for SLO is enabled, you only need to configure CAS for backchannel logout.

For example, if your cas server url is `https://sso.example.com`, then adding `--env 'OAUTH_CAS3_SERVER=https://sso.example.com'` to the docker run command enables support for CAS3 OAuth. Please refer to [Available Configuration Parameters](#available-configuration-parameters) for additional CAS3 configuration parameters.

#### Authentiq

To enable the Authentiq OmniAuth provider for password-less authentication you must register an application with [Authentiq](https://www.authentiq.com/). Please refer to the GitLab [documentation](https://docs.gitlab.com/ce/administration/auth/authentiq.html) for the procedure to generate the client ID and secret key with Authentiq.

Once you have the API client id and client secret generated, configure them using the `OAUTH_AUTHENTIQ_CLIENT_ID` and `OAUTH_AUTHENTIQ_CLIENT_SECRET` environment variables respectively.

For example, if your API key is `xxx` and the API secret key is `yyy`, then adding `--env 'OAUTH_AUTHENTIQ_CLIENT_ID=xxx' --env 'OAUTH_AUTHENTIQ_CLIENT_SECRET=yyy'` to the docker run command enables support for Authentiq OAuth.

You may want to specify `OAUTH_AUTHENTIQ_REDIRECT_URI` as well. The OAuth scope can be altered as well with `OAUTH_AUTHENTIQ_SCOPE` (defaults to `'aq:name email~rs address aq:push'`).

#### Google

To enable the Google OAuth2 OmniAuth provider you must register your application with Google. Google will generate a client ID and secret key for you to use. Please refer to the GitLab [documentation](http://doc.gitlab.com/ce/integration/google.html) for the procedure to generate the client ID and secret key with google.

Once you have the client ID and secret keys generated, configure them using the `OAUTH_GOOGLE_API_KEY` and `OAUTH_GOOGLE_APP_SECRET` environment variables respectively.

For example, if your client ID is `xxx.apps.googleusercontent.com` and client secret key is `yyy`, then adding `--env 'OAUTH_GOOGLE_API_KEY=xxx.apps.googleusercontent.com' --env 'OAUTH_GOOGLE_APP_SECRET=yyy'` to the docker run command enables support for Google OAuth.

You can also restrict logins to a single domain by adding `--env "OAUTH_GOOGLE_RESTRICT_DOMAIN='example.com'"`.

#### Facebook

To enable the Facebook OAuth2 OmniAuth provider you must register your application with Facebook. Facebook will generate an API key and secret for you to use. Please refer to the GitLab [documentation](http://doc.gitlab.com/ce/integration/facebook.html) for the procedure to generate the API key and secret.

Once you have the API key and secret generated, configure them using the `OAUTH_FACEBOOK_API_KEY` and `OAUTH_FACEBOOK_APP_SECRET` environment variables respectively.

For example, if your API key is `xxx` and the API secret key is `yyy`, then adding `--env 'OAUTH_FACEBOOK_API_KEY=xxx' --env 'OAUTH_FACEBOOK_APP_SECRET=yyy'` to the docker run command enables support for Facebook OAuth.

#### Twitter

To enable the Twitter OAuth2 OmniAuth provider you must register your application with Twitter. Twitter will generate an API key and secret for you to use. Please refer to the GitLab [documentation](http://doc.gitlab.com/ce/integration/twitter.html) for the procedure to generate the API key and secret with twitter.

Once you have the API key and secret generated, configure them using the `OAUTH_TWITTER_API_KEY` and `OAUTH_TWITTER_APP_SECRET` environment variables respectively.

For example, if your API key is `xxx` and the API secret key is `yyy`, then adding `--env 'OAUTH_TWITTER_API_KEY=xxx' --env 'OAUTH_TWITTER_APP_SECRET=yyy'` to the docker run command enables support for Twitter OAuth.

#### GitHub

To enable the GitHub OAuth2 OmniAuth provider you must register your application with GitHub. GitHub will generate a Client ID and secret for you to use. Please refer to the GitLab [documentation](http://doc.gitlab.com/ce/integration/github.html) for the procedure to generate the Client ID and secret with github.

Once you have the Client ID and secret generated, configure them using the `OAUTH_GITHUB_API_KEY` and `OAUTH_GITHUB_APP_SECRET` environment variables respectively.

For example, if your Client ID is `xxx` and the Client secret is `yyy`, then adding `--env 'OAUTH_GITHUB_API_KEY=xxx' --env 'OAUTH_GITHUB_APP_SECRET=yyy'` to the docker run command enables support for GitHub OAuth.

Users of GitHub Enterprise may want to specify `OAUTH_GITHUB_URL` and `OAUTH_GITHUB_VERIFY_SSL` as well.

#### GitLab

To enable the GitLab OAuth2 OmniAuth provider you must register your application with GitLab. GitLab will generate a Client ID and secret for you to use. Please refer to the GitLab [documentation](http://doc.gitlab.com/ce/integration/gitlab.html) for the procedure to generate the Client ID and secret with GitLab.

Once you have the Client ID and secret generated, configure them using the `OAUTH_GITLAB_API_KEY` and `OAUTH_GITLAB_APP_SECRET` environment variables respectively.

For example, if your Client ID is `xxx` and the Client secret is `yyy`, then adding `--env 'OAUTH_GITLAB_API_KEY=xxx' --env 'OAUTH_GITLAB_APP_SECRET=yyy'` to the docker run command enables support for GitLab OAuth.

#### BitBucket

To enable the BitBucket OAuth2 OmniAuth provider you must register your application with BitBucket. BitBucket will generate a Client ID and secret for you to use. Please refer to the GitLab [documentation](http://doc.gitlab.com/ce/integration/bitbucket.html) for the procedure to generate the Client ID and secret with BitBucket.

Once you have the Client ID and secret generated, configure them using the `OAUTH_BITBUCKET_API_KEY` and `OAUTH_BITBUCKET_APP_SECRET` environment variables respectively.

For example, if your Client ID is `xxx` and the Client secret is `yyy`, then adding `--env 'OAUTH_BITBUCKET_API_KEY=xxx' --env 'OAUTH_BITBUCKET_APP_SECRET=yyy'` to the docker run command enables support for BitBucket OAuth.

#### SAML

GitLab can be configured to act as a SAML 2.0 Service Provider (SP). This allows GitLab to consume assertions from a SAML 2.0 Identity Provider (IdP) such as Microsoft ADFS to authenticate users. Please refer to the GitLab [documentation](http://doc.gitlab.com/ce/integration/saml.html).

The following parameters have to be configured to enable SAML OAuth support in this image: `OAUTH_SAML_ASSERTION_CONSUMER_SERVICE_URL`, `OAUTH_SAML_IDP_CERT_FINGERPRINT`, `OAUTH_SAML_IDP_SSO_TARGET_URL`, `OAUTH_SAML_ISSUER` and `OAUTH_SAML_NAME_IDENTIFIER_FORMAT`.

You can also override the default "Sign in with" button label with `OAUTH_SAML_LABEL`.

Please refer to [Available Configuration Parameters](#available-configuration-parameters) for the default configurations of these parameters.

#### Crowd

To enable the Crowd server OAuth2 OmniAuth provider you must register your application with Crowd server.

Configure GitLab to enable access the Crowd server by specifying the `OAUTH_CROWD_SERVER_URL`, `OAUTH_CROWD_APP_NAME` and `OAUTH_CROWD_APP_PASSWORD` environment variables.

#### Auth0

To enable the Auth0 OmniAuth provider you must register your application with [auth0](https://auth0.com/).

Configure the following environment variables `OAUTH_AUTH0_CLIENT_ID`, `OAUTH_AUTH0_CLIENT_SECRET` and `OAUTH_AUTH0_DOMAIN` to complete the integration.

#### Microsoft Azure

To enable the Microsoft Azure OAuth2 OmniAuth provider you must register your application with Azure. Azure will generate a Client ID, Client secret and Tenant ID for you to use. Please refer to the GitLab [documentation](http://doc.gitlab.com/ce/integration/azure.html) for the procedure.

Once you have the Client ID, Client secret and Tenant ID generated, configure them using the `OAUTH_AZURE_API_KEY`, `OAUTH_AZURE_API_SECRET` and `OAUTH_AZURE_TENANT_ID` environment variables respectively.

For example, if your Client ID is `xxx`, the Client secret is `yyy` and the Tenant ID is `zzz`, then adding `--env 'OAUTH_AZURE_API_KEY=xxx' --env 'OAUTH_AZURE_API_SECRET=yyy' --env 'OAUTH_AZURE_TENANT_ID=zzz'` to the docker run command enables support for Microsoft Azure OAuth.

### Host UID / GID Mapping

Per default the container is configured to run gitlab as user and group `git` with `uid` and `gid` `1000`. The host possibly uses this ids for different purposes leading to unfavorable effects. From the host it appears as if the mounted data volumes are owned by the host's user/group `1000`.

Also the container processes seem to be executed as the host's user/group `1000`. The container can be configured to map the `uid` and `gid` of `git` to different ids on host by passing the environment variables `USERMAP_UID` and `USERMAP_GID`. The following command maps the ids to user and group `git` on the host.

```bash
docker run --name gitlab -it --rm [options] \
    --env "USERMAP_UID=$(id -u git)" --env "USERMAP_GID=$(id -g git)" \
    gotfix/gitlab:9.3.7
```

When changing this mapping, all files and directories in the mounted data volume `/home/git/data` have to be re-owned by the new ids. This can be achieved automatically using the following command:

```bash
docker run --name gitlab -d [OPTIONS] \
    gotfix/gitlab:9.3.7 app:sanitize
```

### Piwik

If you want to monitor your gitlab instance with [Piwik](http://piwik.org/), there are two options to setup: `PIWIK_URL` and `PIWIK_SITE_ID`.
These options should contain something like:

- `PIWIK_URL=piwik.example.org`
- `PIWIK_SITE_ID=42`


### Grafana

If you want to graph gitlab metrics in [Grafana](https://grafana.com), you have to setup a Grafana instance . The simplest way to do it, is by adding the following to your docker-compose.yml (if you are using docker-compose):
```yaml
version: '2'

services:
  prometheus-server:
    image: prom/prometheus
    ports:
      - 9090:9090
    volumes:
## The sample file can be located at https://gotfix.com/docker/gitlab/raw/master/prometheus/prometheus.yml
      - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
      - ./prometheus/data:/prometheus:Z

  grafana-ui:
    restart: always
    image: grafana/grafana
    ports:
      - 3000:3000
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=password #Make sure to set it to unique value and keep it secure
      - GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-piechart-panel,grafana-simple-json-datasource,cloudflare-app,mtanda-histogram-panel,mtanda-heatmap-epoch-panel,natel-plotly-panel
      - GF_SMTP_ENABLED=true
      - GF_SMTP_HOST=mail.example.com:25 # Set it to the hostname of your email server
      - GF_SMTP_FROM_ADDRESS=gitlab@example.com # This is a from address for your Grafana server
      - GF_SERVER_DOMAIN=grafana.example.com # Your Grafana server hostname
      - GF_SERVER_ROOT_URL=https://grafana.example.com/ #URL to access your Grafana server
      - GF_SERVER_ENFORCE_DOMAIN=true
      - GF_USERS_ALLOW_SIGN_UP=false
    depends_on:
      - prometheus-server
    links:
      - prometheus-server:prometheus
    volumes:
      - ./grafana/lib:/var/lib/grafana:Z
      - ./grafana/log:/var/log/grafana:Z
```
Once you have Prometheus and Grafana servers running, you can proceed with the next step.

#### Setup Grafana dashboard for GitLab

On Grafana UI : 
- Click Data Sources
- Click Add Data Source
- Set Type Prometheus
- Url : http://prometheus-server:9090

You can now import the [following dashboard](https://grafana.net/dashboards/1575), or create a custom one using the Prometheus metrics.

#### GitLab settings to enable metrics agent for Prometheus

| Parameter | Description |
|-----------|-------------|
| `GITLAB_MONITOR_ENABLED` | Enable gitlab-monitor. Default to `false` |
| `GITLAB_MONITOR_PORT`    | Specify port that gitlab-monitor will listen on. Default to `9168` |

### Available Configuration Parameters

**See [Complete list of Configuration Parameters](https://gotfix.com/docker/gitlab/blob/master/docs/configuration_parameters.md).**

# Maintenance

**See [Maintenance](https://gotfix.com/docker/gitlab/blob/master/docs/maintenance.md) for documentation about maintenance.**

# FAQ

## Why did you fork instead of contributing to the original project?

Long story short, since the original project tends to be conservative and their goal is stability, it is not what I would like to run for myself. I prefer to follow Gitlab development cycle closer (when time allows) and play with new features. If you rely on Gitlab for your business and require stability, backwards compatibility, and do not want to update often, I would suggest using the original project. You are welcome to use this fork if you do not mind doing testing yourself.

## Why NGINX is removed from the image?

Best practice dictates that one docker image should serve one purpose, having NGINX in it is not a good idea. At this time it is still in the image but that will change very soon. If you do not know how to setup NGINX outside of this image, take a look at [nginx-proxy](https://github.com/jwilder/nginx-proxy), I am planning to support that instead. I will also prepare set of instructions to use [Caddy](https://gotfix.com/docker/caddy) with this image.

**If you rely on the supplied NGINX, I have prepared [Caddy for GitLab](https://gotfix.com/docker/caddy) to cover those needs. This will allow you to front your Gitlab installation and also have automated SSL using [Let’s Encrypt](https://letsencrypt.org) certificate, and much more. Please take a look at the documentation that [Caddy for GitLab](https://gotfix.com/docker/caddy) provides.**

## Why are you not hosting this project on GitHub and only maintaining mirror there?

This image is for Gitlab CE and I would like to use Gitlab CE to develop and maintain it, at the same time it will help test it as well.

## I would like to help, what should I do?

Thanks, I would love to get some help. You can start by creating account and contributing Merge requests, that will be awesome!

## Why are you not supporting feature X?

Since I do not have unlimited time on my hands, it is very difficult to add/support all of the features. No worries, if you know how to add it to the image, send you Merge request and we will work it out.

## Where are the Kubernetes configuration files?

There is a wonderful project that has a very good set of helm charts to get you started, please take a look here: https://github.com/lwolf/gitlab-chart

# References

* https://github.com/gitlabhq/gitlabhq
* https://github.com/gitlabhq/gitlabhq/blob/master/doc/install/installation.md
* https://github.com/jpetazzo/nsenter
* https://jpetazzo.github.io/2014/03/23/lxc-attach-nsinit-nsenter-docker-0-9/
* https://docs.gitlab.com/ce/user/project/pages/index.html
* https://docs.gitlab.com/ce/administration/pages/index.html
* https://gitlab.com/gitlab-org/gitlab-pages/
* https://gitlab.com/gitlab-org/gitlab-ce/tree/master/doc/update
* https://docs.gitlab.com/ce/administration/pages/source.html - Configuration guide for GitLab pages installed from source
* https://docs.gitlab.com/ce/administration/raketasks/maintenance.html - List of maintanance tasks for GitLab
* https://gitlab.com/gitlab-org/gitlab-runner-docker-cleanup - docker base cleaner for docker, useful on the runner host
* https://docs.gitlab.com/ce/user/project/pages/introduction.html - GitLab pages useful link

