# Maintenance

## Creating backups

GitLab defines a rake task to take a backup of your gitlab installation. The backup consists of all git repositories, uploaded files and as you might expect, the sql database.

Before taking a backup make sure the container is stopped and removed to avoid container name conflicts.

```bash
docker stop gitlab && docker rm gitlab
```

Execute the rake task to create a backup.

```bash
docker run --name gitlab -it --rm [OPTIONS] \
    gotfix/gitlab:9.2.7 app:rake gitlab:backup:create
```

A backup will be created in the backups folder of the [Data Store](#data-store). You can change the location of the backups using the `GITLAB_BACKUP_DIR` configuration parameter.

*P.S. Backups can also be generated on a running instance using `docker exec` as described in the [Rake Tasks](#rake-tasks) section. However, to avoid undesired side-effects, I advice against running backup and restore operations on a running instance.*

When using `docker-compose` you may use the following command to execute the backup.

```bash
docker-compose run --rm gitlab app:rake gitlab:backup:create
```

## Restoring Backups

GitLab also defines a rake task to restore a backup.

Before performing a restore make sure the container is stopped and removed to avoid container name conflicts.

```bash
docker stop gitlab && docker rm gitlab
```

If this is a fresh database that you're doing the restore on, first you need to prepare the database:

```bash
docker run --name gitlab -it --rm [OPTIONS] \
    gotfix/gitlab:8.14.4 app:rake db:setup
```

Execute the rake task to restore a backup. Make sure you run the container in interactive mode `-it`.

```bash
docker run --name gitlab -it --rm [OPTIONS] \
    gotfix/gitlab:9.2.7 app:rake gitlab:backup:restore
```

The list of all available backups will be displayed in reverse chronological order. Select the backup you want to restore and continue.

To avoid user interaction in the restore operation, specify the timestamp of the backup using the `BACKUP` argument to the rake task.

```bash
docker run --name gitlab -it --rm [OPTIONS] \
    gotfix/gitlab:9.2.7 app:rake gitlab:backup:restore BACKUP=1417624827
```

When using `docker-compose` you may use the following command to execute the restore.

```bash
docker-compose run --rm gitlab app:rake gitlab:backup:restore # List available backups
docker-compose run --rm gitlab app:rake gitlab:backup:restore BACKUP=1417624827 # Choose to restore from 1417624827
```

## Host Key Backups (ssh)

SSH keys are not backed up in the normal gitlab backup process. You
will need to backup the `ssh/` directory in the data volume by hand
and you will want to restore it prior to doing a gitlab restore.

## Automated Backups

The image can be configured to automatically take backups `daily`, `weekly` or `monthly` using the `GITLAB_BACKUP_SCHEDULE` configuration option.

Daily backups are created at `GITLAB_BACKUP_TIME` which defaults to `04:00` everyday. Weekly backups are created every Sunday at the same time as the daily backups. Monthly backups are created on the 1st of every month at the same time as the daily backups.

By default, when automated backups are enabled, backups are held for a period of 7 days. While when automated backups are disabled, the backups are held for an infinite period of time. This behavior can be configured via the `GITLAB_BACKUP_EXPIRY` option.

### Amazon Web Services (AWS) Remote Backups

The image can be configured to automatically upload the backups to an AWS S3 bucket. To enable automatic AWS backups first add `--env 'AWS_BACKUPS=true'` to the docker run command. In addition `AWS_BACKUP_REGION` and `AWS_BACKUP_BUCKET` must be properly configured to point to the desired AWS location. Finally an IAM user must be configured with appropriate access permission and their AWS keys exposed through `AWS_BACKUP_ACCESS_KEY_ID` and `AWS_BACKUP_SECRET_ACCESS_KEY`.

More details about the appropriate IAM user properties can found on [doc.gitlab.com](http://doc.gitlab.com/ce/raketasks/backup_restore.html#upload-backups-to-remote-cloud-storage)

For remote backup to self-hosted s3 compatible storage, use `AWS_BACKUP_ENDPOINT`.

AWS uploads are performed alongside normal backups, both through the appropriate `app:rake` command and when an automatic backup is performed.

### Google Cloud Storage (GCS) Remote Backups

The image can be configured to automatically upload the backups to an Google Cloud Storage bucket. To enable automatic GCS backups first add `--env 'GCS_BACKUPS=true'` to the docker run command. In addition `GCS_BACKUP_BUCKET` must be properly configured to point to the desired GCS location.
Finally a couple of `Interoperable storage access keys` user must be created and their keys exposed through `GCS_BACKUP_ACCESS_KEY_ID` and `GCS_BACKUP_SECRET_ACCESS_KEY`.

More details about the Cloud storage interoperability  properties can found on [cloud.google.com/storage](https://cloud.google.com/storage/docs/interoperability)

GCS uploads are performed alongside normal backups, both through the appropriate `app:rake` command and when an automatic backup is performed.

## Rake Tasks

The `app:rake` command allows you to run gitlab rake tasks. To run a rake task simply specify the task to be executed to the `app:rake` command. For example, if you want to gather information about GitLab and the system it runs on.

```bash
docker run --name gitlab -it --rm [OPTIONS] \
    gotfix/gitlab:9.2.7 app:rake gitlab:env:info
```

You can also use `docker exec` to run raketasks on running gitlab instance. For example,

```bash
docker exec --user git -it gitlab bundle exec rake gitlab:env:info RAILS_ENV=production
```

Similarly, to import bare repositories into GitLab project instance

```bash
docker run --name gitlab -it --rm [OPTIONS] \
    gotfix/gitlab:9.2.7 app:rake gitlab:import:repos
```

Or

```bash
docker exec -it gitlab sudo -HEu git bundle exec rake gitlab:import:repos RAILS_ENV=production
```

For a complete list of available rake tasks please refer https://github.com/gitlabhq/gitlabhq/tree/master/doc/raketasks or the help section of your gitlab installation.

*P.S. Please avoid running the rake tasks for backup and restore operations on a running gitlab instance.*

To use the `app:rake` command with `docker-compose` use the following command.

```bash
# For stopped instances
docker-compose run --rm gitlab app:rake gitlab:env:info
docker-compose run --rm gitlab app:rake gitlab:import:repos

# For running instances
docker-compose exec --user git gitlab bundle exec rake gitlab:env:info RAILS_ENV=production
docker-compose exec gitlab sudo -HEu git bundle exec rake gitlab:import:repos RAILS_ENV=production
```

## Import Repositories

Copy all the **bare** git repositories to the `repositories/` directory of the [data store](#data-store) and execute the `gitlab:import:repos` rake task like so:

```bash
docker run --name gitlab -it --rm [OPTIONS] \
    gotfix/gitlab:9.2.7 app:rake gitlab:import:repos
```

Watch the logs and your repositories should be available into your new gitlab container.

See [Rake Tasks](#rake-tasks) for more information on executing rake tasks.
Usage when using `docker-compose` can also be found there.

## Upgrading

> **Important Notice**
>
> Since GitLab release `8.6.0` PostgreSQL users should enable `pg_trgm` extension on the GitLab database. Refer to GitLab's [Postgresql Requirements](http://doc.gitlab.com/ce/install/requirements.html#postgresql-requirements) for more information

GitLabHQ releases new versions on the 22nd of every month, bugfix releases immediately follow. I update this project almost immediately when a release is made (at least it has been the case so far). If you are using the image in production environments I recommend that you delay updates by a couple of days after the gitlab release, allowing some time for the dust to settle down.

To upgrade to newer gitlab releases, simply follow this 4 step upgrade procedure.

- **Step 1**: Update the docker image.

For docker:
```bash
docker pull gotfix/gitlab:9.2.7
```

For docker-compose:

Update `docker-compose.yml` and change `image:` variable to `gotfix/gitlab:9.2.7`, to have it look like snippet below:
```yaml
...
  gitlab:
    restart: always
    image: gotfix/gitlab:9.2.7
...
```

And then perform the following:
```bash
docker-compose pull
```

- **Step 2**: Stop and remove the currently running image

For docker:
```bash
docker stop gitlab
docker rm gitlab
```

For docker-compose:
```bash
docker-compose down
```

- **Step 3**: Create a backup

For docker:
```bash
docker run --name gitlab -it --rm [OPTIONS] \
    gotfix/gitlab:x.x.x app:rake gitlab:backup:create
```

For docker-compose:
```bash
docker-compose run --rm gitlab app:rake gitlab:backup:create
```

Replace `x.x.x` with the version you are upgrading from. For example, if you are upgrading from version `6.0.0`, set `x.x.x` to `6.0.0`

> Also please read through [official backup guide](https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/raketasks/backup_restore.md) to have better understanding of the backup and restore steps.

- **Step 4**: Start the image

> **Note**: Since GitLab `8.0.0` you need to provide the `GITLAB_SECRETS_DB_KEY_BASE` parameter while starting the image.

> **Note**: Since GitLab `8.11.0` you need to provide the `GITLAB_SECRETS_SECRET_KEY_BASE` and `GITLAB_SECRETS_OTP_KEY_BASE` parameters while starting the image. These should initially both have the same value as the contents of the `/home/git/data/.secret` file. See [Available Configuration Parameters](#available-configuration-parameters) for more information on these parameters.

For docker:
```bash
docker run --name gitlab -d [OPTIONS] gotfix/gitlab:9.2.7
```

For docker-compose:
```bash
docker-compose up -d
```

## Shell Access

For debugging and maintenance purposes you may want access the containers shell. If you are using docker version `1.3.0` or higher you can access a running containers shell using `docker exec` command.

For docker:
```bash
docker exec -it gitlab bash
```

For docker-compose:
```bash
docker-compose exec gitlab bash
```

