#!/usr/bin/env bash

buildkite:init () {
  ask_for buildkiteOrganization 'Buildkite organization'
  ask_for buildkiteToken 'Buildkite API token'

  cs_export CS_BUILDKITE_ORG ${buildkiteOrganization:?}
  cs_export CS_BUILDKITE_TOKEN ${buildkiteToken:?}
  cs_export CS_BUILDKITE_BADGE_URL
  cs_export CS_BUILDKITE_BUILD_URL
  cs_export CS_BUILDKITE_WEBHOOK_URL
}

buildkite:exec () {
  buildkite:scaffold:files
  buildkite:scaffold:pipeline
  buildkite:scaffold:webhook
}

buildkite:scaffold:files () {
  if [[ ! -d .buildkite ]]; then
    mkdir .buildkite
    cs_copy ${CS_MODULES_DIR:?}/buildkite/pipeline.yml ./.buildkite/pipeline.yml
    log_success "- Created Buildkite files"
  fi
}

buildkite:scaffold:pipeline () {
  local statuscode
  local response

  statuscode=$(curl "https://api.buildkite.com/v2/organizations/${CS_BUILDKITE_ORG:?}/pipelines/${CS_SERVICE_NAME:?}" \
    --silent \
    -I \
    -H "Authorization: Bearer ${CS_BUILDKITE_TOKEN:?}" \
    -w '%{http_code}' \
    -o /dev/null)

  if [[ "${statuscode}" == "404" ]]; then
    response=$(curl "https://api.buildkite.com/v2/organizations/${CS_BUILDKITE_ORG:?}/pipelines" \
      --silent \
      -H "Authorization: Bearer ${CS_BUILDKITE_TOKEN:?}" \
      -d "{
          \"name\": \"${CS_SERVICE_NAME:?}\",
          \"repository\": \"git@github.com:${CS_GITHUB_ORG:?}/${CS_SERVICE_NAME:?}.git\",
          \"default_branch\": \"master\",
          \"branch_configuration\": \"master\",
          \"steps\": [
            {
              \"type\": \"script\",
              \"name\": \"Setup :package:\",
              \"command\": \"buildkite-agent pipeline upload\"
            }
          ],
          \"skip_queued_branch_builds\": true,
          \"cancel_running_branch_builds\": true
        }")
    log_success "- Buildkite pipeline created"
  else
    log_warn "- Buildkite pipeline already exists"
    response=$(curl --silent "https://api.buildkite.com/v2/organizations/${CS_BUILDKITE_ORG:?}/pipelines/${CS_SERVICE_NAME:?}" -H "Authorization: Bearer ${CS_BUILDKITE_TOKEN:?}")
  fi

  cs_export CS_BUILDKITE_BADGE_URL "$(echo ${response:?} | jq -r '.badge_url')"
  cs_export CS_BUILDKITE_BUILD_URL "$(echo ${response} | jq -r '.web_url')"
  cs_export CS_BUILDKITE_WEBHOOK_URL "$(echo ${response} | jq -r '.provider.webhook_url')"
}

buildkite:scaffold:webhook () {
  # TODO: Handle dependency on github module
  if [[ "${CS_USE_GITHUB}" == "true" ]]; then
    local response
    response=$(curl https://api.github.com/repos/${CS_GITHUB_ORG:?}/$CS_SERVICE_NAME/hooks \
      -H "Authorization: token ${CS_GITHUB_TOKEN:?}" \
      -s)

    if [[ "$response" == *"${CS_BUILDKITE_WEBHOOK_URL}"* ]]; then
      log_warn "- Buildkite webhook already added to Github repository"
    else
      curl https://api.github.com/repos/${CS_GITHUB_ORG:?}/${CS_SERVICE_NAME}/hooks \
        --silent \
        -X POST \
        -H "Authorization: token ${CS_GITHUB_TOKEN:?}" \
        -o /dev/null \
        -d "{
          \"name\": \"web\",
          \"active\": true,
          \"events\": [
            \"push\",
            \"pull_request\",
            \"deployment\"
          ],
          \"config\": {
            \"url\": \"${CS_BUILDKITE_WEBHOOK_URL:?}\",
            \"content_type\": \"json\"
          }"
      log_success "- Created Buildkite webhook for Github repository"
    fi
  fi
}
