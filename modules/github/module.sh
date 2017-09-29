#!/usr/bin/env bash

github:init () {
  ask_for githubOrganization 'Github organization'
  ask_for githubToken 'Github API token'
  cs_export CS_GITHUB_ORG "${githubOrganization:?}"
  cs_export CS_GITHUB_TOKEN "${githubToken:?}"
  cs_export CS_GITHUB_REPOSITORY "git@github.com:${CS_GITHUB_ORG:?}/${CS_SERVICE_NAME:?}.git"
}

github:exec () {
  local statuscode
  statuscode=$(curl https://api.github.com/repos/${CS_GITHUB_ORG:?}/${CS_SERVICE_NAME:?} \
    -H "Authorization: token ${CS_GITHUB_TOKEN:?}" \
    -w '%{http_code}' \
    -s -o /dev/null)

  if [[ "$statuscode" == "200" ]]; then
    log_warn '- Github repository already exists'
  else
    statuscode=$(curl https://api.github.com/orgs/${CS_GITHUB_ORG:?}/repos \
      -H "Authorization: token ${CS_GITHUB_TOKEN:?}" \
      -o /dev/null \
      --write-out "%{http_code}\n" \
      --silent \
      -d "{
            \"name\": \"${CS_SERVICE_NAME:?}\",
            \"private\": true
          }")

    if [[ "$statuscode" == "201" ]]; then
      log_success "- Github repository created (https://github.com/${CS_GITHUB_ORG:?}/${CS_SERVICE_NAME:?}/)"
    else
      log_error "- Failed to create Github repository (HTTP $statuscode)"
      exit 1
    fi
  fi
}
