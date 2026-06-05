#!/usr/bin/env bash
set -euo pipefail

printf '$ freight check\n'
printf 'package  hello 0.1.0\n'
printf 'success  freight.toml is valid\n\n'

printf '$ freight fetch\n'
printf 'resolved 2 packages\n'
printf 'cached fmt in .pkgs/fmt\n'
printf 'cached zlib in .pkgs/zlib\n\n'

printf '$ freight build --graph\n'
printf 'hello 0.1.0\n'
printf '├── fmt 10\n'
printf '└── zlib 1\n'
printf 'build order: fmt, zlib, hello\n\n'

printf '$ freight build --time-passes\n'
printf 'Building hello [dev]\n'
printf 'Compiling src/main.cpp\n'
printf 'Linking hello\n'
printf 'time  src/main.cpp  84ms\n'
printf 'finished dev build\n\n'

printf '$ freight test\n'
printf 'test math_smoke ... ok\n'
printf 'test cli_smoke ... ok\n\n'

printf '$ freight run -- --help\n'
printf 'hello 0.1.0\n'
printf 'usage: hello [OPTIONS]\n'
