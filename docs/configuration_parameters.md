# Available Configuration Parameters

*Please refer the docker run command options for the `--env-file` flag where you can specify all required environment variables in a single file. This will save you from writing a potentially long docker run command. Alternatively you can use docker-compose.*

Below is the complete list of available configuration options segregated by category. Those options will allow you to customize your installation of GitLab.

## GitLab Monitor

| Parameter | Description |
|-----------|-------------|
| `GITLAB_MONITOR_ENABLED` | Enable gitlab-monitor. Default to `false` |
| `GITLAB_MONITOR_PORT`    | Specify port that gitlab-monitor will listen on. Default to `9168` |

## GitLab Pages

| Parameter | Description |
|-----------|-------------|
| `GITLAB_PAGES_ENABLED` | Enable GitLab Pages. Default to `false` |
| `GITLAB_PAGES_DOMAIN` | GitLab Pages domain. Default tp `example.com` |
| `GITLAB_PAGES_PORT` | Port that is used by gitlab-pages daemon to listen for requests. Default to `8090` |
| `GITLAB_PAGES_PROXY_PORT` | Port that is used by upstream proxy to listen for requests. Default to `GITLAB_PAGES_PORT` |
| `GITLAB_PAGES_HTTPS` | Run gitlab-pages in HTTPS mode. Default to `false` |
| `GITLAB_PAGES_METRICS_PORT` | This will expose general metrics about the Go runtime and pages application for Prometheus to scrape. Default to `9235` |
| `SSL_PAGES_KEY_PATH` | Path to the gitlab-pages SSL key. Default to `$GITLAB_DATA_DIR/certs/pages.key` |
| `SSL_PAGES_CERT_PATH` | Path to the gitlab-pages SSL certificate. Default to `$GITLAB_DATA_DIR/certs/pages.crt` |
| `GITLAB_PAGES_EXTERNAL_HTTP` | Port for gitlab-pages that will accept HTTP requests. Default `8888` |
| `GITLAB_PAGES_EXTERNAL_HTTPS` | Port for gitlab-pages that will accept HTTPS requests. Default `8443` |
| `GITLAB_PAGES_EXTERNAL_HTTP_IP` | Comma separated list of external IPs for gitlab-pages that will accept HTTP requests. Used to enable custom domain setup by the user. IPv6 should be written as `[2001:0db8::1]`, surrounded with square brackets. No Defaults. Example `1.2.3.4:80,[2001:0db8::1]:80`|
| `GITLAB_PAGES_EXTERNAL_HTTPS_IP` | Comma separated list of external IP for gitlab-pages that will accept HTTPS requests. Used to enable custom domain setup by the user. IPv6 should be written as `[2001:0db8::1]`, surrounded with square brackets. No Defaults. Example `1.2.3.4:443,[2001:0db8::1]:443`|

## GitLab specific

| Parameter | Description |
|-----------|-------------|
| `DEBUG` | Set this to `true` to enable entrypoint debugging. |
| `VERBOSE` | Set this to `true` to enable more verbose logging. |
| `GITLAB_HOST` | The hostname of the GitLab server. Defaults to `localhost` |
| `GITLAB_CI_HOST` | If you are migrating from GitLab CI use this parameter to configure the redirection to the GitLab service so that your existing runners continue to work without any changes. No defaults. |
| `GITLAB_PORT` | The port of the GitLab server. This value indicates the public port on which the GitLab application will be accessible on the network and appropriately configures GitLab to generate the correct urls. Defaults to `443` if `GITLAB_HTTPS=true`, else defaults to `80`. |
| `GITLAB_SECRETS_DB_KEY_BASE` | Encryption key for GitLab CI secret variables, as well as import credentials, in the database. Ensure that your key is at least 32 characters long and that you don't lose it. You can generate one using `pwgen -Bsv1 64`. If you are migrating from GitLab CI, you need to set this value to the value of `GITLAB_CI_SECRETS_DB_KEY_BASE`. No defaults. |
| `GITLAB_SECRETS_SECRET_KEY_BASE` | Encryption key for session secrets. Ensure that your key is at least 64 characters long and that you don't lose it. This secret can be rotated with minimal impact - the main effect is that previously sent password reset emails will no longer work. You can generate one using `pwgen -Bsv1 64`. No defaults. |
| `GITLAB_SECRETS_OTP_KEY_BASE` |  Encryption key for OTP related stuff with  GitLab. Ensure that your key is at least 64 characters long and that you don't lose it. **If you lose or change this secret, 2FA will stop working for all users.** You can generate one using `pwgen -Bsv1 64`. No defaults. |
| `GITLAB_TIMEZONE` | Configure the timezone for the gitlab application. This configuration does not effect cron jobs. Defaults to `UTC`. See the list of [acceptable values](http://api.rubyonrails.org/classes/ActiveSupport/TimeZone.html). |
| `GITLAB_ROOT_PASSWORD` | The password for the root user on first run. Defaults to `5iveL!fe`. GitLab requires this to be at least 8 characters long. |
| `GITLAB_ROOT_EMAIL` | The email for the root user on first run. Defaults to `admin@example.com` |
| `GITLAB_EMAIL` | The email address for the GitLab server. Defaults to value of `SMTP_USER`, else defaults to `example@example.com`. |
| `GITLAB_EMAIL_DISPLAY_NAME` | The name displayed in emails sent out by the GitLab mailer. Defaults to `GitLab`. |
| `GITLAB_EMAIL_REPLY_TO` | The reply-to address of emails sent out by GitLab. Defaults to value of `GITLAB_EMAIL`, else defaults to `noreply@example.com`. |
| `GITLAB_EMAIL_SUBJECT_SUFFIX` | The e-mail subject suffix used in e-mails sent by GitLab. No defaults. |
| `GITLAB_EMAIL_ENABLED` | Enable or disable gitlab mailer. Defaults to the `SMTP_ENABLED` configuration. |
| `GITLAB_INCOMING_EMAIL_ADDRESS` | The incoming email address for reply by email. Defaults to the value of `IMAP_USER`, else defaults to `reply@example.com`. Please read the [reply by email](http://doc.gitlab.com/ce/incoming_email/README.html) documentation to currently set this parameter. |
| `GITLAB_INCOMING_EMAIL_ENABLED` | Enable or disable gitlab reply by email feature. Defaults to the value of `IMAP_ENABLED`. |
| `GITLAB_USERNAME_CHANGE` | Enable or disable ability for users to change their username. Defaults to `true`. |
| `GITLAB_CREATE_GROUP` | Enable or disable ability for users to create groups. Defaults to `true`. |
| `GITLAB_PROJECTS_ISSUES` | Set if *issues* feature should be enabled by default for new projects. Defaults to `true`. |
| `GITLAB_PROJECTS_MERGE_REQUESTS` | Set if *merge requests* feature should be enabled by default for new projects. Defaults to `true`. |
| `GITLAB_PROJECTS_WIKI` | Set if *wiki* feature should be enabled by default for new projects. Defaults to `true`. |
| `GITLAB_PROJECTS_SNIPPETS` | Set if *snippets* feature should be enabled by default for new projects. Defaults to `false`. |
| `GITLAB_PROJECTS_BUILDS` | Set if *builds* feature should be enabled by default for new projects. Defaults to `true`. |
| `GITLAB_PROJECTS_CONTAINER_REGISTRY` | Set if *container_registry* feature should be enabled by default for new projects. Defaults to `true`. |
| `GITLAB_WEBHOOK_TIMEOUT` | Sets the timeout for webhooks. Defaults to `10` seconds. |
| `GITLAB_TIMEOUT` | Sets the timeout for git commands. Defaults to `10` seconds. |
| `GITLAB_MAX_OBJECT_SIZE` | Maximum size (in bytes) of a git object (eg. a commit) in bytes. Defaults to `20971520`, i.e. `20` megabytes. |
| `GITLAB_NOTIFY_ON_BROKEN_BUILDS` | Enable or disable broken build notification emails. Defaults to `true` |
| `GITLAB_NOTIFY_PUSHER` | Add pusher to recipients list of broken build notification emails. Defaults to `false` |
| `GITLAB_REPOS_DIR` | The git repositories folder in the container. Defaults to `/home/git/data/repositories` |
| `GITLAB_BACKUP_DIR` | The backup folder in the container. Defaults to `/home/git/data/backups` |
| `GITLAB_BUILDS_DIR` | The build traces directory. Defaults to `/home/git/data/builds` |
| `GITLAB_DOWNLOADS_DIR` | The repository downloads directory. A temporary zip is created in this directory when users click **Download Zip** on a project. Defaults to `/home/git/data/tmp/downloads`. |
| `GITLAB_SHARED_DIR` | The directory to store the build artifacts. Defaults to `/home/git/data/shared` |
| `GITLAB_ARTIFACTS_ENABLED` | Enable/Disable GitLab artifacts support. Defaults to `true`. |
| `GITLAB_ARTIFACTS_DIR` | Directory to store the artifacts. Defaults to `$GITLAB_SHARED_DIR/artifacts` |
| `GITLAB_LFS_ENABLED` | Enable/Disable Git LFS support. Defaults to `true`. |
| `GITLAB_LFS_OBJECTS_DIR` | Directory to store the lfs-objects. Defaults to `$GITLAB_SHARED_DIR/lfs-objects` |
| `GITLAB_MATTERMOST_ENABLED` | Enable/Disable GitLab Mattermost for *Add Mattermost button*. Defaults to `false`. |
| `GITLAB_MATTERMOST_URL` | Sets Mattermost URL. Defaults to `https://mattermost.example.com`. |
| `GITLAB_BACKUP_SCHEDULE` | Setup cron job to automatic backups. Possible values `disable`, `daily`, `weekly` or `monthly`. Disabled by default |
| `GITLAB_BACKUP_EXPIRY` | Configure how long (in seconds) to keep backups before they are deleted. By default when automated backups are disabled backups are kept forever (0 seconds), else the backups expire in 7 days (604800 seconds). |
| `GITLAB_BACKUP_PG_SCHEMA` | Specify the PostgreSQL schema for the backups. No defaults, which means that all schemas will be backed up. see #524 |
| `GITLAB_BACKUP_ARCHIVE_PERMISSIONS` | Sets the permissions of the backup archives. Defaults to `0600`. [See](http://doc.gitlab.com/ce/raketasks/backup_restore.html#backup-archive-permissions) |
| `GITLAB_BACKUP_TIME` | Set a time for the automatic backups in `HH:MM` format. Defaults to `04:00`. |
| `GITLAB_BACKUP_SKIP` | Specified sections are skipped by the backups. Defaults to empty, i.e. `lfs,uploads`. [See](http://doc.gitlab.com/ce/raketasks/backup_restore.html#create-a-backup-of-the-gitlab-system) |
| `GITLAB_SSH_HOST` | The ssh host. Defaults to **GITLAB_HOST**. |
| `GITLAB_SSH_PORT` | The ssh port number. Defaults to `22`. |
| `GITLAB_SSH_MAXSTARTUPS` | The ssh "MaxStartups" parameter, defaults to `100:30:200`. |
| `GITLAB_RELATIVE_URL_ROOT` | The relative url of the GitLab server, e.g. `/git`. No default. |
| `GITLAB_TRUSTED_PROXIES` | Add IP address reverse proxy to trusted proxy list, otherwise users will appear signed in from that address. Currently only a single entry is permitted. No defaults. |
| `GITLAB_REGISTRY_ENABLED` | Enables the GitLab Container Registry. Defaults to `false`. |
| `GITLAB_REGISTRY_HOST` | Sets the GitLab Registry Host. Defaults to `registry.example.com` |
| `GITLAB_REGISTRY_PORT` | Sets the GitLab Registry Port. Defaults to `443`. |
| `GITLAB_REGISTRY_API_URL` | Sets the GitLab Registry API URL. Defaults to `http://localhost:5000` |
| `GITLAB_REGISTRY_KEY_PATH` | Sets the GitLab Registry Key Path. Defaults to `config/registry.key` |
| `GITLAB_REGISTRY_CERT_PATH` | Sets the GitLab Registry Certificate Path. Defaults to `config/registry.crt` |
| `GITLAB_REGISTRY_DIR` | Directory to store the container images will be shared with registry. Defaults to `$GITLAB_SHARED_DIR/registry` |
| `GITLAB_REGISTRY_ISSUER` | Sets the GitLab Registry Issuer. Defaults to `gitlab-issuer`. |
| `GITLAB_HTTPS` | Set to `true` to enable https support, disabled by default. |
| `GITLAB_WORKHORSE_TIMEOUT` | Timeout for gitlab workhorse http proxy. Defaults to `5m0s`. |
| `GITLAB_WORKHORSE_PORT` | Port that workhorse will listen on for connection. Defaults to `8181`. |
| `GITLAB_WORKHORSE_SENTRY_DSN` | URL for sentry DSN, ex.: `https://abab1212ab:abab1212@sentry.io/123456`. No defaults. |
| `GITLAB_WORKHORSE_CI_LONGPOLLING_DURATION` | CI Long polling duration for job requesting for runners. Defaults to `0s`, disabled. |
| `SSL_SELF_SIGNED` | Set to `true` when using self signed ssl certificates. `false` by default. |
| `SSL_CA_CERTIFICATES_PATH` | List of SSL certificates to trust. Defaults to `/home/git/data/certs/ca.crt`. |
| `SSL_VERIFY_CLIENT` | Enable verification of client certificates using the `SSL_CA_CERTIFICATES_PATH` file. Defaults to `false` |
| `REDIS_HOST` | The hostname of the redis server. Defaults to `localhost` |
| `REDIS_PORT` | The connection port of the redis server. Defaults to `6379`. |
| `REDIS_PASSWORD` | The connection password for the redis server. No password by default. **Password should not contain any URL unsafe characters.** Use `pwgen -Bsv1 16` to generate one.|
| `REDIS_DB_NUMBER` | The redis database number. Defaults to '0'. |
| `UNICORN_WORKERS` | The number of unicorn workers to start. Defaults to `3`. |
| `UNICORN_TIMEOUT` | Sets the timeout of unicorn worker processes. Defaults to `60` seconds. |
| `SIDEKIQ_CONCURRENCY` | The number of concurrent sidekiq jobs to run. Defaults to `25` |
| `SIDEKIQ_SHUTDOWN_TIMEOUT` | Timeout for sidekiq shutdown. Defaults to `4` |
| `SIDEKIQ_MEMORY_KILLER_MAX_RSS` | Non-zero value enables the SidekiqMemoryKiller. Defaults to `1000000`. For additional options refer [Configuring the MemoryKiller](http://doc.gitlab.com/ce/operations/sidekiq_memory_killer.html) |
| `DB_ADAPTER` | The database type. Possible values: `mysql2`, `postgresql`. Defaults to `postgresql`. |
| `DB_ENCODING` | The database encoding. For `DB_ADAPTER` values `postresql` and `mysql2`, this parameter defaults to `unicode` and `utf8mb4` respectively. |
| `DB_HOST` | The database server hostname. Defaults to `localhost`. |
| `DB_PORT` | The database server port. Defaults to `3306` for mysql and `5432` for postgresql. |
| `DB_NAME` | The database database name. Defaults to `gitlabhq_production` |
| `DB_USER` | The database database user. Defaults to `root` |
| `DB_PASS` | The database database password. Defaults to no password |
| `DB_POOL` | The database database connection pool count. Defaults to `10`. |
| `SMTP_ENABLED` | Enable mail delivery via SMTP. Defaults to `true` if `SMTP_USER` is defined, else defaults to `false`. |
| `SMTP_DOMAIN` | SMTP domain. Defaults to` www.gmail.com` |
| `SMTP_HOST` | SMTP server host. Defaults to `smtp.gmail.com`. |
| `SMTP_PORT` | SMTP server port. Defaults to `587`. |
| `SMTP_USER` | SMTP username. |
| `SMTP_PASS` | SMTP password. |
| `SMTP_STARTTLS` | Enable STARTTLS. Defaults to `true`. |
| `SMTP_TLS` | Enable SSL/TLS. Defaults to `false`. |
| `SMTP_OPENSSL_VERIFY_MODE` | SMTP openssl verification mode. Accepted values are `none`, `peer`, `client_once` and `fail_if_no_peer_cert`. Defaults to `none`. |
| `SMTP_AUTHENTICATION` | Specify the SMTP authentication method. Defaults to `login` if `SMTP_USER` is set. |
| `SMTP_CA_ENABLED` | Enable custom CA certificates for SMTP email configuration. Defaults to `false`. |
| `SMTP_CA_PATH` | Specify the `ca_path` parameter for SMTP email configuration. Defaults to `/home/git/data/certs`. |
| `SMTP_CA_FILE` | Specify the `ca_file` parameter for SMTP email configuration. Defaults to `/home/git/data/certs/ca.crt`. |
| `IMAP_ENABLED` | Enable mail delivery via IMAP. Defaults to `true` if `IMAP_USER` is defined, else defaults to `false`. |
| `IMAP_HOST` | IMAP server host. Defaults to `imap.gmail.com`. |
| `IMAP_PORT` | IMAP server port. Defaults to `993`. |
| `IMAP_USER` | IMAP username. |
| `IMAP_PASS` | IMAP password. |
| `IMAP_SSL` | Enable SSL. Defaults to `true`. |
| `IMAP_STARTTLS` | Enable STARTSSL. Defaults to `false`. |
| `IMAP_MAILBOX` | The name of the mailbox where incoming mail will end up. Defaults to `inbox`. |
| `LDAP_ENABLED` | Enable LDAP. Defaults to `false` |
| `LDAP_LABEL` | Label to show on login tab for LDAP server. Defaults to 'LDAP' |
| `LDAP_HOST` | LDAP Host |
| `LDAP_PORT` | LDAP Port. Defaults to `389` |
| `LDAP_UID` | LDAP UID. Defaults to `sAMAccountName` |
| `LDAP_METHOD` | LDAP method, Possible values are `ssl`, `tls` and `plain`. Defaults to `plain` |
| `LDAP_BIND_DN` | No default. |
| `LDAP_PASS` | LDAP password |
| `LDAP_TIMEOUT` | Timeout, in seconds, for LDAP queries. Defaults to `10`. |
| `LDAP_ACTIVE_DIRECTORY` | Specifies if LDAP server is Active Directory LDAP server. If your LDAP server is not AD, set this to `false`. Defaults to `true`, |
| `LDAP_ALLOW_USERNAME_OR_EMAIL_LOGIN` | If enabled, GitLab will ignore everything after the first '@' in the LDAP username submitted by the user on login. Defaults to `false` if `LDAP_UID` is `userPrincipalName`, else `true`. |
| `LDAP_BLOCK_AUTO_CREATED_USERS` | Locks down those users until they have been cleared by the admin. Defaults to `false`. |
| `LDAP_BASE` | Base where we can search for users. No default. |
| `LDAP_USER_FILTER` | Filter LDAP users. No default. |
| `LDAP_USER_ATTRIBUTE_USERNAME` | fields for the identification of a user. Default to `['uid', 'userid', 'sAMAccountName']`. |
| `LDAP_USER_ATTRIBUTE_MAIL` | fields for the shown mail address. Default to `['mail', 'email', 'userPrincipalName']`. |
| `LDAP_USER_ATTRIBUTE_NAME` | field for the used username of a user. Default to `cn`. |
| `LDAP_USER_ATTRIBUTE_FIRSTNAME` | field for the forename of a user. Default to `givenName`. |
| `LDAP_USER_ATTRIBUTE_LASTNAME` | field for the surname of a user. Default to `sn`. |
| `OAUTH_ENABLED` | Enable OAuth support. Defaults to `true` if any of the support OAuth providers is configured, else defaults to `false`. |
| `OAUTH_AUTO_SIGN_IN_WITH_PROVIDER` | Automatically sign in with a specific OAuth provider without showing GitLab sign-in page. Accepted values are `cas3`, `github`, `bitbucket`, `gitlab`, `google_oauth2`, `facebook`, `twitter`, `saml`, `crowd`, `auth0` and `azure_oauth2`. No default. |
| `OAUTH_ALLOW_SSO` | Comma separated list of oauth providers for single sign-on. This allows users to login without having a user account. The account is created automatically when authentication is successful. Accepted values are `cas3`, `github`, `bitbucket`, `gitlab`, `google_oauth2`, `facebook`, `twitter`, `saml`, `crowd`, `auth0` and `azure_oauth2`. No default. |
| `OAUTH_BLOCK_AUTO_CREATED_USERS` | Locks down those users until they have been cleared by the admin. Defaults to `true`. |
| `OAUTH_AUTO_LINK_LDAP_USER` | Look up new users in LDAP servers. If a match is found (same uid), automatically link the omniauth identity with the LDAP account. Defaults to `false`. |
| `OAUTH_AUTO_LINK_SAML_USER` | Allow users with existing accounts to login and auto link their account via SAML login, without having to do a manual login first and manually add SAML. Defaults to `false`. |
| `OAUTH_EXTERNAL_PROVIDERS` | Comma separated list if oauth providers to disallow access to `internal` projects. Users creating accounts via these providers will have access internal projects. Accepted values are `cas3`, `github`, `bitbucket`, `gitlab`, `google_oauth2`, `facebook`, `twitter`, `saml`, `crowd`, `auth0` and `azure_oauth2`. No default. |
| `OAUTH_CAS3_LABEL` | The "Sign in with" button label. Defaults to "cas3". |
| `OAUTH_CAS3_SERVER` | CAS3 server URL. No defaults. |
| `OAUTH_CAS3_DISABLE_SSL_VERIFICATION` | Disable CAS3 SSL verification. Defaults to `false`. |
| `OAUTH_CAS3_LOGIN_URL` | CAS3 login URL. Defaults to `/cas/login` |
| `OAUTH_CAS3_VALIDATE_URL` | CAS3 validation URL. Defaults to `/cas/p3/serviceValidate` |
| `OAUTH_CAS3_LOGOUT_URL` | CAS3 logout URL. Defaults to `/cas/logout` |
| `OAUTH_GOOGLE_API_KEY` | Google App Client ID. No defaults. |
| `OAUTH_GOOGLE_APP_SECRET` | Google App Client Secret. No defaults. |
| `OAUTH_GOOGLE_RESTRICT_DOMAIN` | List of Google App restricted domains. Value is comma separated list of single quoted groups. Example: `'exemple.com','exemple2.com'`. No defaults. |
| `OAUTH_FACEBOOK_API_KEY` | Facebook App API key. No defaults. |
| `OAUTH_FACEBOOK_APP_SECRET` | Facebook App API secret. No defaults. |
| `OAUTH_TWITTER_API_KEY` | Twitter App API key. No defaults. |
| `OAUTH_TWITTER_APP_SECRET` | Twitter App API secret. No defaults. |
| `OAUTH_AUTHENTIQ_CLIENT_ID` | authentiq Client ID. No defaults. |
| `OAUTH_AUTHENTIQ_CLIENT_SECRET` | authentiq Client secret. No defaults. |
| `OAUTH_AUTHENTIQ_SCOPE` | Scope of Authentiq Application Defaults to `'aq:name email~rs address aq:push'`|
| `OAUTH_AUTHENTIQ_REDIRECT_URI` |  Callback URL for Authentiq. No defaults. |
| `OAUTH_GITHUB_API_KEY` | GitHub App Client ID. No defaults. |
| `OAUTH_GITHUB_APP_SECRET` | GitHub App Client secret. No defaults. |
| `OAUTH_GITHUB_URL` | Url to the GitHub Enterprise server. Defaults to https://github.com |
| `OAUTH_GITHUB_VERIFY_SSL` | Enable SSL verification while communicating with the GitHub server. Defaults to `true`. |
| `OAUTH_GITLAB_API_KEY` | GitLab App Client ID. No defaults. |
| `OAUTH_GITLAB_APP_SECRET` | GitLab App Client secret. No defaults. |
| `OAUTH_BITBUCKET_API_KEY` | BitBucket App Client ID. No defaults. |
| `OAUTH_BITBUCKET_APP_SECRET` | BitBucket App Client secret. No defaults. |
| `OAUTH_SAML_ASSERTION_CONSUMER_SERVICE_URL` | The URL at which the SAML assertion should be received. When `GITLAB_HTTPS=true`, defaults to `https://${GITLAB_HOST}/users/auth/saml/callback` else defaults to `http://${GITLAB_HOST}/users/auth/saml/callback`. |
| `OAUTH_SAML_IDP_CERT_FINGERPRINT` | The SHA1 fingerprint of the certificate. No Defaults. |
| `OAUTH_SAML_IDP_SSO_TARGET_URL` | The URL to which the authentication request should be sent. No defaults. |
| `OAUTH_SAML_ISSUER` | The name of your application. When `GITLAB_HTTPS=true`, defaults to `https://${GITLAB_HOST}` else defaults to `http://${GITLAB_HOST}`. |
| `OAUTH_SAML_LABEL` | The "Sign in with" button label. Defaults to "Our SAML Provider". |
| `OAUTH_SAML_NAME_IDENTIFIER_FORMAT` | Describes the format of the username required by GitLab, Defaults to `urn:oasis:names:tc:SAML:2.0:nameid-format:transient` |
| `OAUTH_SAML_GROUPS_ATTRIBUTE` | Map groups attribute in a SAMLResponse to external groups. No defaults. |
| `OAUTH_SAML_EXTERNAL_GROUPS` | List of external groups in a SAMLResponse. Value is comma separated list of single quoted groups. Example: `'group1','group2'`. No defaults. |
| `OAUTH_SAML_ATTRIBUTE_STATEMENTS_EMAIL` | Map 'email' attribute name in a SAMLResponse to entries in the OmniAuth info hash, No defaults. See [GitLab documentation](http://doc.gitlab.com/ce/integration/saml.html#attribute_statements) for more details. |
| `OAUTH_SAML_ATTRIBUTE_STATEMENTS_NAME` | Map 'name' attribute in a SAMLResponse to entries in the OmniAuth info hash, No defaults. See [GitLab documentation](http://doc.gitlab.com/ce/integration/saml.html#attribute_statements) for more details. |
| `OAUTH_SAML_ATTRIBUTE_STATEMENTS_FIRST_NAME` | Map 'first_name' attribute in a SAMLResponse to entries in the OmniAuth info hash, No defaults. See [GitLab documentation](http://doc.gitlab.com/ce/integration/saml.html#attribute_statements) for more details. |
| `OAUTH_SAML_ATTRIBUTE_STATEMENTS_LAST_NAME` | Map 'last_name' attribute in a SAMLResponse to entries in the OmniAuth info hash, No defaults. See [GitLab documentation](http://doc.gitlab.com/ce/integration/saml.html#attribute_statements) for more details. |
| `OAUTH_SAML_PRIVATE_KEY` | Provide gitlab a private key to use for secure saml requests and assertions. No default, and must be coupled with `OAUTH_SAML_CERTIFICATE` to take effect. See [ruby-saml](https://github.com/onelogin/ruby-saml#signing) for more details. |
|
| `OAUTH_SAML_CERTIFICATE` | Provide gitlab a public certificate to use for secure saml requests and assertions. No default, and must be coupled with `OAUTH_SAML_PRIVATE_KEY` to take effect. |
| `OAUTH_CROWD_SERVER_URL` | Crowd server url. No defaults. |
| `OAUTH_CROWD_APP_NAME` | Crowd server application name. No defaults. |
| `OAUTH_CROWD_APP_PASSWORD` | Crowd server application password. No defaults. |
| `OAUTH_AUTH0_CLIENT_ID` | Auth0 Client ID. No defaults. |
| `OAUTH_AUTH0_CLIENT_SECRET` | Auth0 Client secret. No defaults. |
| `OAUTH_AUTH0_DOMAIN` | Auth0 Domain. No defaults. |
| `OAUTH_AZURE_API_KEY` | Azure Client ID. No defaults. |
| `OAUTH_AZURE_API_SECRET` | Azure Client secret. No defaults. |
| `OAUTH_AZURE_TENANT_ID` | Azure Tenant ID. No defaults. |
| `GITLAB_GRAVATAR_HTTP_URL` | Sets a custom gravatar url. Defaults to `http://www.gravatar.com/avatar/%{hash}?s=%{size}&d=identicon`. This can be used for [Libravatar integration](http://doc.gitlab.com/ce/customization/libravatar.html). |
| `GITLAB_GRAVATAR_HTTPS_URL` | Same as above, but for https. Defaults to `https://secure.gravatar.com/avatar/%{hash}?s=%{size}&d=identicon`. |
| `USERMAP_UID` | Sets the uid for user `git` to the specified uid. Defaults to `1000`. |
| `USERMAP_GID` | Sets the gid for group `git` to the specified gid. Defaults to `USERMAP_UID` if defined, else defaults to `1000`. |
| `GOOGLE_ANALYTICS_ID` | Google Analytics ID. No defaults. |
| `PIWIK_URL` | Sets the Piwik URL. No defaults. |
| `PIWIK_SITE_ID` | Sets the Piwik site ID. No defaults. |
| `AWS_BACKUPS` | Enables automatic uploads to an Amazon S3 instance. Defaults to `false`. |
| `AWS_BACKUP_REGION` | AWS region. No defaults. |
| `AWS_BACKUP_ENDPOINT` | AWS endpoint. No defaults. |
| `AWS_BACKUP_ACCESS_KEY_ID` | AWS access key id. No defaults. |
| `AWS_BACKUP_SECRET_ACCESS_KEY` | AWS secret access key. No defaults. |
| `AWS_BACKUP_BUCKET` | AWS bucket for backup uploads. No defaults. |
| `AWS_BACKUP_MULTIPART_CHUNK_SIZE` | Enables mulitpart uploads when file size reaches a defined size. See at [AWS S3 Docs](http://docs.aws.amazon.com/AmazonS3/latest/dev/uploadobjusingmpu.html) |
| `GCS_BACKUPS` | Enables automatic uploads to an Google Cloud Storage (GCS) instance. Defaults to `false`.  |
| `GCS_BACKUP_ACCESS_KEY_ID` | GCS access key id. No defaults |
| `GCS_BACKUP_SECRET_ACCESS_KEY` | GCS secret access key. No defaults |
| `GCS_BACKUP_BUCKET` | GCS bucket for backup uploads. No defaults |
| `GITLAB_ROBOTS_PATH` | Location of custom `robots.txt`. Uses GitLab's default `robots.txt` configuration by default. See [www.robotstxt.org](http://www.robotstxt.org) for examples. |
| `RACK_ATTACK_ENABLED` | Enable/disable rack middleware for blocking & throttling abusive requests Defaults to `true`. |
| `RACK_ATTACK_WHITELIST` | Always allow requests from whitelisted host. Defaults to `127.0.0.1` |
| `RACK_ATTACK_MAXRETRY` | Number of failed auth attempts before which an IP should be banned. Defaults to `10` |
| `RACK_ATTACK_FINDTIME` | Number of seconds before resetting the per IP auth attempt counter. Defaults to `60`. |
| `RACK_ATTACK_BANTIME` | Number of seconds an IP should be banned after too many auth attempts. Defaults to `3600`. |
| `GITLAB_TRACK_DEPLOYMENTS` | Enable tracking of deployments. See [rake tasks](https://docs.gitlab.com/ce/administration/raketasks/maintenance.html#tracking-deployments). Defaults to `false`. |

## Gitaly

| Parameter | Description |
|-----------|-------------|
| `GITALY_ENABLED`                | Enable Gitaly. Default `true`. |
| `GITALY_ADDRESS`                | Set Gitaly server address. `unix:/path/to/socket.file` or `tcp://host:port`. Default `unix:/home/git/gitlab/tmp/sockets/private/gitaly.socket`. |
| `GITALY_PROMETHEUS_LISTEN_ADDR` | Specify port for Gitaly to emit metrics. Default `localhost:9236`. |

