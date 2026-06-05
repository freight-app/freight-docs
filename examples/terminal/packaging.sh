#!/usr/bin/env bash
set -euo pipefail

printf '$ freight build --release\n'
printf 'Building hello [release]\n'
printf 'Compiling src/main.cpp\n'
printf 'Linking hello\n'
printf 'finished release build\n\n'

printf '$ freight install --prefix /usr/local --destdir target/stage --no-build\n'
printf 'Installing /usr/local (destdir: target/stage)\n'
printf 'Install (bin) target/stage/usr/local/bin/hello\n'
printf 'success 1 file installed\n\n'

printf '$ freight package --target x86_64-linux-gnu,aarch64-linux-gnu\n'
printf 'Packaging hello [x86_64-linux-gnu]\n'
printf 'success -> target/package/hello-0.1.0-x86_64-linux.tar.gz\n'
printf 'Packaging hello [aarch64-linux-gnu]\n'
printf 'success -> target/package/hello-0.1.0-aarch64-linux.tar.gz\n\n'

printf '$ freight package --installer\n'
printf 'Installer hello\n'
printf 'success -> target/package/hello-0.1.0-x86_64-linux.deb\n'
