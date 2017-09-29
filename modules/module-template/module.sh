#!/usr/bin/env bash

module:init () {
  ask_for 'foo' 'Give me foo' 'bar'
  cs_export CS_MODULE_FOO ${foo:?}
  cs_export CS_MODULE_BAR
}

module:exec () {
  cs_export CS_MODULE_BAR "$(date +%s | sha256sum | base64 | head -c 32 ; echo)"
}
