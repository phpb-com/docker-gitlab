Bash library to compare Gitlab versions
========================

> This library is entirely based on github.com/fsaintjacques/semver-tool, and it was also forked from it.

# Usage

In your script include the library and call defined methods:

```bash
#!/bin/bash
set -e

source src/glver

echo $(gl_vercmp $1 $2)
```

# Gitlab specific versioning quirks ...

It would have been nicer if Gitlab followed Semantic Versioning, but they don't. Below is a quick description of how one version of GL compares to the other.

- `9.1.0.pre` is older than `9.1.0` and older than `9.1.0-rc1`
- `9.1.0` is newer than `9.1.0-rc1` and older than `9.1.0-1`
- `9.1-stable` is equal to `9.1.0`, `9.1.1`, and `9.1.0-1` but newer than `9.1.0.pre` and `9.1.0-rc1`
- `9-1-stable` is equivalent of `9.1-stable`. That is a stable branch that is not tagged and is updated with the code that is tagged for MINOR release. To be more complient with semver, I will only use dotted versioning for stable: `9.1-stable`
- During normal release cycle it follows semantic versioning, and releases are tagged (from old to new) `9.0.0`, `9.0.1`, `9.1.0`, etc ...
