#!/usr/bin/env bash

directories:init () {
  ask_for 'directoriesSourceDir' 'Source code directory' ./src
  ask_for 'directoriesTestsDir' 'Tests directory' ./test
  cs_export CS_DIRECTORIES_SOURCE "${directoriesSourceDir:?}"
  cs_export CS_DIRECTORIES_TESTS "${directoriesTestsDir:?}"
}

directories:exec () {
  local created=false
  if [[ ! -d ${CS_DIRECTORIES_SOURCE:?} ]]; then mkdir ${CS_DIRECTORIES_SOURCE:?}; created=true; fi
  if [[ ! -d ${CS_DIRECTORIES_TESTS:?} ]]; then mkdir ${CS_DIRECTORIES_TESTS:?}; created=true; fi
  [[ $created == true ]] && log_success '- Created directories (empty)'
}
