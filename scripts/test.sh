#!/usr/bin/env bash

set -euo pipefail

./scripts/build.sh
cat > /tmp/test-builder.toml << EOF
  [[buildpacks]]
  uri = "/Users/pivotal/workspace/procfile"
  [[order]]
      [[order.group]]
      id = "paketo-buildpacks/procfile"
      version = "4.0.0"
  [stack]
  id = "io.buildpacks.stacks.windows.servercore"
  build-image = "build:dev-dotnet-framework-ltsc2019-cnb"
  run-image = "run:dev-dotnet-framework-ltsc2019-cnb"
EOF

pack builder create test-proc-builder -c /tmp/test-builder.toml
pack build test-proc-app --builder test-proc-builder --path /tmp/sample-app --trust-builder
docker run --rm test-proc-app