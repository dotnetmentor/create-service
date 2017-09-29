#!/usr/bin/env bash

editorconfig:init () {
  cs_export CS_EDITORCONFIG_FILE ./.editorconfig
}

editorconfig:exec () {
  local created=false
  if [[ ! -f ${CS_EDITORCONFIG_FILE:?} ]]; then cs_copy "${CS_MODULES_DIR:?}/editorconfig/.editorconfig" "${CS_EDITORCONFIG_FILE:?}"; created=true; fi
  [[ $created == true ]] && log_success '- Created .editorconfig file'
}
