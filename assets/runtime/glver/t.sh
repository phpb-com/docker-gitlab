#!/bin/bash
set -e

source src/glver

RC=0

test_vercmp() {
  local result
  result=$(gl_vercmp "$1" "$2")
  if (( $result == $3 )); then
    echo "PASS: $1 $2 :: as expected, return value $3"
  else
    echo "FAIL: $1 $2 :: expected return value $3, received $result"
    RC=1
  fi
}

# Check equalty
test_vercmp 9.1.0 9.1.0           0
test_vercmp 9.1.0-1 9.1.0-1       0
test_vercmp 9.1.0 9.1-stable      0
test_vercmp 9.1.3 9.1-stable      0
test_vercmp 9.1.0-1 9.1-stable    0
test_vercmp 9.1-stable 9-1-stable 0
# Same but in reverse
test_vercmp 9.1.0 9.1.0           0
test_vercmp 9.1.0-1 9.1.0-1       0
test_vercmp 9.1-stable 9.1.0      0
test_vercmp 9.1-stable 9.1.3      0
test_vercmp 9.1-stable 9.1.0-1    0
test_vercmp 9-1-stable 9.1-stable 0

# Check un-equalty and correct order
test_vercmp 9.1.0 9.1.1           -1
test_vercmp 9.1.0 9.1.0-1         -1

# -stable
test_vercmp 9.0.0 9.1-stable      -1
test_vercmp 9.0.3 9.1-stable      -1
test_vercmp 9.0.0-1 9.1-stable    -1
test_vercmp 9.0-stable 9.1-stable -1
test_vercmp 9.1.0.pre 9.1-stable  -1
test_vercmp 9.1.0-rc2 9.1-stable  -1
test_vercmp 9.1-stable 9.2.0.pre  -1
test_vercmp 9.1-stable 9.2.0-rc1  -1
test_vercmp 9.1-stable 9.2.0      -1

# -rc1, 2, 3, etc ...
test_vercmp 9.1.0-rc2 9.1.0       -1
test_vercmp 9.1.0.pre 9.1.0-rc1   -1
test_vercmp 9.1.0 9.1.0-rc1        1
test_vercmp 9.1.0-rc1 9.1.0.pre    1

# .pre
test_vercmp 9.1.0.pre 9.1.0-rc1   -1
test_vercmp 9.1.0.pre 9.1.0       -1
test_vercmp 9.1.0 9.1.0.pre        1
test_vercmp 9.1.0-rc1 9.1.0.pre    1

exit ${RC}
