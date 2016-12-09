#!/usr/bin/env bash

set -e

export RAILS_ENV=test

echo
echo "== Custom scripts =="

function print_start {
FUNCTION=$1
TIMING_MARKER=$2
  echo -en "travis_fold:start:$FUNCTION\r"
  echo -en "travis_time:start:$TIMING_MARKER\r"
  echo "=== $FUNCTION ==="
}

function print_end {
  FUNCTION=$1
  TIMING_MARKER=$2
  START_TIME=$3
  END_TIME=$4
  ELAPSED_TIME=$(($END_TIME - $START_TIME))
  echo "travis_time:end:$TIMING_MARKER:start=$START_TIME,finish=$END_TIME,duration=$ELAPSED_TIME"
  echo -en "travis_fold:end:$FUNCTION\r"
}

function run {
  FUNCTION=$1
  TIMING_MARKER=$(echo $FUNCTION | md5sum | cut -b1-8)
  print_start $FUNCTION $TIMING_MARKER
  START_TIME=$(date +%s%N)
  $FUNCTION
  END_TIME=$(date +%s%N)
  print_end $FUNCTION $TIMING_MARKER $START_TIME $END_TIME
}

function install_gems {
  bundle install --jobs=3 --retry=3 --deployment --path=${BUNDLE_PATH:-vendor/bundle}
}

run "install_gems"
rm -f $CASHER_DIR/mtime.yml
echo done
