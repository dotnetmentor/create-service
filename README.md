# create-service

A generator for easy setup/scaffolding of new services, written in bash.

A set of modules is combined to create a service based on your specific needs.
`create-service` is extensible and new modules can be added and customized.
Simply make a fork and add/change it. See the modules section for details on each module.

Features in short:

  - Generated README.md
  - Koshu setup (taksrunner)
  - Git setup
  - Github setup
  - Buildkite setup
  - Docker setup

## Pre-requisites

  - jq (https://stedolan.github.io/jq/)
  - sed
  - grep
  - curl (module)
  - git (module)

## Usage

Clone this repository and run:

    ./create-service <name>

You may specify a set of defaults to use when running `create-service` by creating a `config.json` in the `create-service` repository root. This file is by default ignored (.gitignore) and not checked as it may contain secrets.

## Modules

- [buildkite](modules/buildkite/README.md)
- [directories](modules/directories/README.md)
- [docker](modules/docker/README.md)
- [editorconfig](modules/editorconfig/README.md)
- [git](modules/git/README.md)
- [github](modules/github/README.md)
- [koshu](modules/koshu/README.md)
- [readme](modules/readme/README.md)

### Creating a module

A good place to start is by looking at the existing modules. There is also a module-template located in the modules directory that can act as a base for new modules. To follow is a set of conventions/best practices to consider when creating/modifying a module.

### Module conventions

- All modules **should** be idempotent to avoid side effects when running the script multiple times.
- Environment variables made available to other modules **must** be prefixed `CS_MODULENAME_`.
- Environment variables made available to other modules **must** be defined in `<module>:init` using `cs_export`.
- Environment variables set at runtime (in `module:exec`) **must** first be defined in `<module>:init` using `cs_export`.
- All functions in a module.sh **must** be prefixed with `<module>:` to avoid function collision (ie: `koshu:internal_func`).

## Roadmap

- Make it work on windows
- Ask, show, execute
- Add support for "dry-run" (A default value of <computed> indicates that the value will be set at runtime)
- Add support for verbose flag (print content of module readme files)
- Run in docker using mounted volumes (to handle pre-requisites like jq and envsubst)?
- Additional language specific features
