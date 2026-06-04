#!/usr/bin/env bash
set -euo pipefail

printf '$ freight init hello\n'
printf 'created package hello\n'
printf 'wrote freight.toml\n\n'

printf '$ cd hello\n\n'

printf '$ freight add zlib\n'
printf 'added zlib = "latest" to freight.toml\n\n'

printf '$ freight fetch\n'
printf 'resolved 1 package\n'
printf 'downloaded zlib\n'
printf 'cached sources in .pkgs/zlib\n\n'

printf '$ freight build --release\n'
printf 'compiling hello\n'
printf 'linking target/release/hello\n'
printf 'finished release build\n'
