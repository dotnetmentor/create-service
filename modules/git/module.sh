#!/usr/bin/env bash

git:init () {
  cs_export CS_GIT_IGNORE_FILE ./.gitignore
}

git:exec () {
  git:scaffold:ignorefile
  git:scaffold:repository
}

# ---------------------------------------------------
# git
# ---------------------------------------------------

git:scaffold:ignorefile () {
  if [[ ! -f ${CS_GIT_IGNORE_FILE:?} ]]; then
    cs_copy "${CS_MODULES_DIR:?}/git/.gitignore" "${CS_GIT_IGNORE_FILE:?}"
    log_success '- Created .gitignore file'
  fi
}

git:scaffold:repository () {
  if [[ ! -d .git ]]; then
    git init > /dev/null
    git add .
    git commit -am "Created service ${CS_SERVICE_NAME:?}" > /dev/null
    log_success '- Initialized local git repository'

    # TODO: Handle dependency on github module
    if [[ "${CS_USE_GITHUB}" == "true" ]]; then
      git remote add origin "${CS_GITHUB_REPOSITORY:?}"
      log_success "- Added remote 'origin' to git repository (${CS_GITHUB_REPOSITORY:?})"
    fi
  fi
}
