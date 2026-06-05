---
id: terminal-demos
title: Terminal demos
---

Terminal examples are authored as reproducible scenarios:

- VHS `.tape` files render the animated demos used by the website.
- Matching shell scenarios are recorded with asciinema and rendered back to text transcripts for readers who prefer copyable output.

## Demo index

| Scenario | Tape source | Transcript | Related docs |
|---|---|---|---|
| Quickstart | [`quickstart.tape`](https://github.com/freight-app/freight-docs/blob/main/examples/terminal/quickstart.tape) | [Quickstart](#quickstart-transcript) | [Freight ecosystem guide](./intro.md) |
| Build workflow | [`build-workflow.tape`](https://github.com/freight-app/freight-docs/blob/main/examples/terminal/build-workflow.tape) | [Build workflow](#build-workflow-transcript) | [Build workflow](./build-workflow.md) |
| Dependency management | [`dependency-management.tape`](https://github.com/freight-app/freight-docs/blob/main/examples/terminal/dependency-management.tape) | [Dependency management](#dependency-management-transcript) | [Dependency management](./dependency-management.md) |
| Packaging | [`packaging.tape`](https://github.com/freight-app/freight-docs/blob/main/examples/terminal/packaging.tape) | [Packaging](#packaging-transcript) | [Install and package](./install-package.md) |

## Regenerate examples

Install the external tools first:

```bash
go install github.com/charmbracelet/vhs@latest
cargo install --locked asciinema
```

Then render everything from the docs repo root:

```bash
bun run examples:terminal
```

The script writes:

- GIF output to `static/img/terminal/`
- asciinema casts to `static/casts/`
- plain transcripts to `generated/terminal/`

## Quickstart transcript

```text
$ freight init hello
created package hello
wrote freight.toml

$ cd hello

$ freight add zlib
added zlib = "latest" to freight.toml

$ freight fetch
resolved 1 package
downloaded zlib
cached sources in .pkgs/zlib

$ freight build --release
compiling hello
linking target/release/hello
finished release build
```

## Build workflow transcript

```text
$ freight check
package  hello 0.1.0
success  freight.toml is valid

$ freight fetch
resolved 2 packages
cached fmt in .pkgs/fmt
cached zlib in .pkgs/zlib

$ freight build --graph
hello 0.1.0
├── fmt 10
└── zlib 1
build order: fmt, zlib, hello

$ freight build --time-passes
Building hello [dev]
Compiling src/main.cpp
Linking hello
time  src/main.cpp  84ms
finished dev build

$ freight test
test math_smoke ... ok
test cli_smoke ... ok

$ freight run -- --help
hello 0.1.0
usage: hello [OPTIONS]
```

## Dependency management transcript

```text
$ freight add fmt@10
added fmt = "10" to freight.toml

$ freight add openssl
added openssl = "latest" to freight.toml

$ freight add mathlib --path ../mathlib
added mathlib = { path = "../mathlib" } to freight.toml

$ freight fetch
resolved 3 packages
downloaded fmt
downloaded openssl
cached packages in .pkgs/

$ freight tree
hello 0.1.0
├── fmt 10.2.1
├── openssl 3.2.0
└── mathlib 0.1.0 (path ../mathlib)

$ freight outdated
all dependencies are current
```

## Packaging transcript

```text
$ freight build --release
Building hello [release]
Compiling src/main.cpp
Linking hello
finished release build

$ freight install --prefix /usr/local --destdir target/stage --no-build
Installing /usr/local (destdir: target/stage)
Install (bin) target/stage/usr/local/bin/hello
success 1 file installed

$ freight package --target x86_64-linux-gnu,aarch64-linux-gnu
Packaging hello [x86_64-linux-gnu]
success -> target/package/hello-0.1.0-x86_64-linux.tar.gz
Packaging hello [aarch64-linux-gnu]
success -> target/package/hello-0.1.0-aarch64-linux.tar.gz

$ freight package --installer
Installer hello
success -> target/package/hello-0.1.0-x86_64-linux.deb
```
