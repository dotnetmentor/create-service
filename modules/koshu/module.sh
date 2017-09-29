#!/usr/bin/env bash

koshu:init () {
  cs_export CS_KOSHU_FILE './koshufile'
  cs_export CS_TASKRUNNER_BUILD_COMMAND './koshu.sh build'
  cs_export CS_TASKRUNNER_DEPLOY_COMMAND './koshu.sh deploy'
}

koshu:exec () {
  if [[ ! -f ${CS_KOSHU_FILE:?} ]]; then
    curl -s https://raw.githubusercontent.com/kristofferahl/koshu-shell/master/src/koshu.sh > ./koshu.sh
    cs_copy "${CS_MODULES_DIR:?}/koshu/koshufile" "${CS_KOSHU_FILE:?}"
    chmod +x ./koshu.sh
    chmod +x ${CS_KOSHU_FILE:?}
    log_success '- Added koshu and koshufile'
  fi
}
