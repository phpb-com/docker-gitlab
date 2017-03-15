# Introduction

Those are the steps that should be taken to upgrade GitLab, GitLab Shell, GitLab Monitor, GitLab Pages, GitLab Workhorse, etc... to the next version.

# Update to the next version

## GitLab

 - Check [GitLab official repo](https://gitlab.com/gitlab-org/gitlab-ce) and see if new [tag](https://gitlab.com/gitlab-org/gitlab-ce/tags) is available.
 - Check [Changelog](https://gitlab.com/gitlab-org/gitlab-ce/blob/master/CHANGELOG.md) and see if there are any changes that might break the build. Make sure to check the full list starting at the current version in this repo and until the target upgrade version.
 - If it is a major update (i.e., 8.X -> 9.X, 8.1 -> 8.2), check [update documents](https://gitlab.com/gitlab-org/gitlab-ce/tree/master/doc/update).
 - Resolve all of the new requirements and changes
 - Update relevant files with new version number
   - Update DOCKER_GITLAB_IMAGE_VERSION in [Dockerfile](Dockerfile) - mainly to invalidate quay.io cache and build a fresh image.
   - check https://gitlab.com/gitlab-org/gitlab-shell/tags
   - check https://gitlab.com/gitlab-org/gitlab-monitor/tags
   - check https://gitlab.com/gitlab-org/gitlab-pages/tags
   - check https://gitlab.com/gitlab-org/gitlab-workhorse/tags
   - check https://gitlab.com/gitlab-org/gitlab-ce/tags
   - Update each version in a separate commit in Dockerfile
 - Try to build image (run `make`) after changes are applied.
 - **NOTE** Watch for availability of [Gitaly](https://gitlab.com/gitlab-org/gitaly) to include in defailt image. Should be available in 9.1~
