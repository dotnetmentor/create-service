#!/usr/bin/env bash

readme:init () {
  cs_export CS_README_FILE ./README.md
}

readme:exec () {
  if [[ ! -f ${CS_README_FILE:?} ]]; then
    cs_copy "${CS_MODULES_DIR:?}/readme/README.md.template" "${CS_README_FILE:?}"
    log_success '- Created README.md'
  fi
}
