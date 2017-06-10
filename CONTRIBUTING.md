# Introduction

Those are the steps that should be taken to upgrade GitLab, GitLab Shell, GitLab Monitor, GitLab Pages, GitLab Workhorse, etc... to the next version.

# General Tips and Tricks

## README.md

- (Re)Generate TOC: https://github.com/jonschlinkert/markdown-toc
- Update Version number: `sed -i -- 's/X.X.X/Y.Y.Y/g' README.md` - from version X.X.X to Y.Y.Y

# Update to the next version

## GitLab

 - Check [GitLab official repo](https://gitlab.com/gitlab-org/gitlab-ce) and see if new [tag](https://gitlab.com/gitlab-org/gitlab-ce/tags) is available.
 - Check [Changelog](https://gitlab.com/gitlab-org/gitlab-ce/blob/master/CHANGELOG.md) and see if there are any changes that might break the build. Make sure to check the full list starting at the current version in this repo and until the target upgrade version.
 - If it is a major update (i.e., 8.X -> 9.X, 8.1 -> 8.2), check [update documents](https://gitlab.com/gitlab-org/gitlab-ce/tree/master/doc/update).
 - Check https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/install/installation.md for any changes or additions.
 - Resolve all of the new requirements and changes
 - Update relevant files with new version number
   - (Updated automatically, **DO NOT UPDATE**) check https://gitlab.com/gitlab-org/gitlab-shell/tags
   - (Updated automatically, **DO NOT UPDATE**) check https://gitlab.com/gitlab-org/gitaly/tags
   - (Updated automatically, **DO NOT UPDATE**) check https://gitlab.com/gitlab-org/gitlab-pages/tags
   - (Updated automatically, **DO NOT UPDATE**) check https://gitlab.com/gitlab-org/gitlab-workhorse/tags
   - check https://gitlab.com/gitlab-org/gitlab-monitor/tags
   - check https://gitlab.com/gitlab-org/gitlab-ce/tags
   - Update each version in a separate commit in Dockerfile
 - Handy oneliner to update version `sed -i -- 's/X\.X\.X/Y.Y.Y/g' README.md VERSION docker-compose.yml docs/* Dockerfile`
 - Try to build image (run `make`) after changes are applied.
 - **NOTE** Watch for availability of [Gitaly](https://gitlab.com/gitlab-org/gitaly) to include in defailt image. Should be available in 9.1~

## Release

### Update version from A.B.C to X.Y.Z
 - Update documentation `sed -i -- 's/A\.B\.C/X.Y.Z/g' README.md docker-compose.yml Dockerfile docs/*`
 - Perform commit `git commit -a -m "Update documentation for X.Y.Z"`
 - Add Changelog
 - Perform commit `git commit -a -m "Update changelog for X.Y.Z"`
 - Update VERSION file
 - Perform Commit `git commit -a -m "Release X.Y.Z"`
 - Tag the commit with release `git tag -a X.X.X-X -m "Release X.X.X-X"`
 - Set git config for tags `git config --global push.followTags true`
 - Push commit and tag `git push --follow-tags`
