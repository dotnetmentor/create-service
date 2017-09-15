# create-service

A generator for easy setup/scaffolding of new services written in bash

Features:

  - Generated README.md
  - Common dotfiles (.gitignore .editorconfig etc)
  - Common directory structure
  - Koshu setup (taksrunner)
  - Git setup
  - Github setup
  - Buildkite setup (pipeline.yml, pipeline, github webhook)
  - Docker setup (Dockerfile, docker-compose.yml)
  - Reading values from config.json

## Usage

Simply open a terminal and run:

    bash <(curl -s https://raw.githubusercontent.com/dotnetmentor/create-service/master/create-service)

Or you could clone this repository and run:

    ./create-service <name>

## Roadmap

  - Ask, show, execute
  - Run in docker using mounted volumes (to handle pre-requisites like jq and envsubst)?
  - Additional language specific features (optional)?
