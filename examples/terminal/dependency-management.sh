#!/usr/bin/env bash
set -euo pipefail

printf '$ freight add fmt@10\n'
printf 'added fmt = "10" to freight.toml\n\n'

printf '$ freight add openssl\n'
printf 'added openssl = "latest" to freight.toml\n\n'

printf '$ freight add mathlib --path ../mathlib\n'
printf 'added mathlib = { path = "../mathlib" } to freight.toml\n\n'

printf '$ freight fetch\n'
printf 'resolved 3 packages\n'
printf 'downloaded fmt\n'
printf 'downloaded openssl\n'
printf 'cached packages in .pkgs/\n\n'

printf '$ freight tree\n'
printf 'hello 0.1.0\n'
printf '├── fmt 10.2.1\n'
printf '├── openssl 3.2.0\n'
printf '└── mathlib 0.1.0 (path ../mathlib)\n\n'

printf '$ freight outdated\n'
printf 'all dependencies are current\n'
