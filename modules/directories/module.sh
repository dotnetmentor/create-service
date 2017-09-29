#!/usr/bin/env bash

directories:init () {
  ask_for 'source_dir' 'Source code directory' ./src
  ask_for 'tests_dir' 'Tests directory' ./test
  cs_export CS_DIRECTORIES_SOURCE "${source_dir:?}"
  cs_export CS_DIRECTORIES_TESTS "${tests_dir:?}"
}

directories:exec () {
  local created=false
  if [[ ! -d ${CS_DIRECTORIES_SOURCE:?} ]]; then mkdir ${CS_DIRECTORIES_SOURCE:?}; created=true; fi
  if [[ ! -d ${CS_DIRECTORIES_TESTS:?} ]]; then mkdir ${CS_DIRECTORIES_TESTS:?}; created=true; fi
  [[ $created == true ]] && log_success '- Created directories (empty)'
}
