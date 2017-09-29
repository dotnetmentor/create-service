#!/usr/bin/env bash

docker:init () {
  ask_for dockerOrganization 'Docker organization'
  cs_export CS_DOCKER_ORGANIZATION "${dockerOrganization:?}"
  cs_export CS_DOCKER_IMAGE_NAME "${CS_SERVICE_NAME:?}"
  cs_export CS_DOCKER_IMAGE_TAG 'latest'
}

docker:exec () {
  if [[ ! -f ./Dockerfile ]]; then
    cs_copy "${CS_MODULES_DIR}/docker/Dockerfile" "./Dockerfile"
    log_success "- Created Dockerfile"
  fi

  if [[ ! -f ./.dockerignore ]]; then
    cs_copy "${CS_MODULES_DIR}/docker/.dockerignore" "./.dockerignore"
    log_success "- Created .dockerignore file"
  fi

  [[ ! -d ./.deployment ]] && mkdir "./.deployment"

  if [[ ! -f ./.deployment/docker-compose.yml ]]; then
    cs_copy "${CS_MODULES_DIR}/docker/docker-compose.yml" "./.deployment/docker-compose.yml"
    log_success "- Created docker-compose.yml"
  fi
}
