---
id: intro
title: Freight ecosystem guide
slug: /
---

Freight is the build tool, package format, registry, documentation browser, and editor integration surface for native projects.

It is aimed at C, C++, Fortran, assembly, and mixed-language projects that need reproducible builds, project-local dependencies, IDE metadata, and a package registry without stitching together several unrelated tools.

Freight keeps the project contract in `freight.toml`, downloads packages into `.pkgs/`, writes build output into `target/`, and generates editor metadata under `.freight/`.

## Core docs

- [`freight.toml`](./freight-toml.md) explains project manifests, targets, features, and dependency declarations.
- [Build workflow](./build-workflow.md) explains project discovery, profiles, build artifacts, graph output, and troubleshooting.
- [Dependency management](./dependency-management.md) explains registry, path, Git, URL, system, optional, and platform-specific dependencies.
- [Install and package](./install-package.md) explains `freight install`, staged installs, archives, target packaging, and native installers.
- [`config.toml`](./config-toml.md) explains system, user, and project-local machine configuration.
- [DAP and LSP](./dap-lsp.md) explains editor debugging and language-server integration.
- [DAG build system](./dag.md) explains package build stages and C++20 module ordering.

## Project setup

A Freight project is described by `freight.toml`. Keep source layout conventional and let Freight generate the build metadata used by compilers, IDEs, and package consumers.

```text
hello/
├── freight.toml
├── include/
│   └── hello/hello.h
└── src/
    ├── hello.cpp
    └── main.cpp
```

```bash
freight init hello
cd hello
freight build
freight run
```

The terminal demos are reproducible. See [Terminal demos](./terminal-demos.md) for the VHS tapes and text transcripts used in this guide.

## Manifest example

This is a small library plus executable with C++20 enabled, a public header, a registry dependency, a local path dependency, and a Windows-only package:

```toml
[package]
name = "hello"
version = "0.1.0"
license = "MIT"

[lib]
name = "hello"
srcs = ["src/hello.cpp"]
hdrs = ["include/hello/hello.h"]

[[bin]]
name = "hello"
src = "src/main.cpp"

[language.cpp]
std = "c++20"

[compiler]
backend = "clang"
warnings = "all"
includes = ["include"]

[dependencies]
fmt = "10"
mathlib = { path = "../mathlib" }

[os.windows.dependencies]
winapi = "0.3"
```

Run `freight check` after editing the manifest to catch invalid fields and incompatible dependency declarations before compiling.

## Dependencies

Dependencies can come from the registry, local paths, Git repositories, or URL archives. Registry dependencies are cached under `.pkgs/`; compiled artifacts stay under `target/`.

```toml
[dependencies]
fmt = "10"

[dependencies.local-lib]
path = "../local-lib"

[os.windows.dependencies]
winapi = "0.3"
```

See [Dependency management](./dependency-management.md) for scopes, optional deps, platform-specific sections, and source-build behavior.

## Build and release workflow

Local builds usually stay in the `dev` profile until release validation. The normal loop is check, fetch, build, test, run:

```bash
freight check
freight fetch
freight build --time-passes
freight test
freight build --release
```

Freight can also show the graph it is about to build:

```bash
freight build --graph
freight build --graph --graph-format mermaid
```

Release artifacts can be installed to a prefix or packaged for distribution:

```bash
freight install --prefix /usr/local --destdir target/stage --no-build
freight package --target x86_64-linux-gnu,aarch64-linux-gnu
```

See [Build workflow](./build-workflow.md) and [Install and package](./install-package.md) for the full flow.

## Publish and registry workflow

The registry stores package metadata, sources, uploaded README content, generated documentation indexes, and prebuilts. Use channels for release lanes and ownership for shared package maintenance.

```bash
freight login --registry https://registry.example.com
freight publish --registry https://registry.example.com
freight fetch
freight build --release
```

For package development, publish from a clean release build and keep generated archives under `target/package/`:

```bash
freight test --release
freight package
freight publish --registry https://registry.example.com
```

## Documentation

`freight doc` extracts source comments into a structured symbol index. Published docs appear in the package page through the source documentation viewer, while this guide covers the ecosystem workflow.

```bash
freight doc
freight doc --json
freight publish --registry https://registry.example.com
```

## Editor support

The editor extensions start `freight lsp` for `freight.toml` diagnostics, completion, hover, and source-language passthroughs. VS Code and Neovim wrappers live with the workspace; JetBrains support is planned.

The VS Code extension also exposes Freight tasks and debugging:

```text
Freight: Build
Freight: Run
Freight: Debug
Freight: Generate compile_commands.json
```

The generated compile database is kept in `.freight/lsp/<profile>/compile_commands.json`, so clangd sees the same explicit Freight package includes that the build uses.

## Common commands

| Goal | Command |
|---|---|
| Validate manifest | `freight check` |
| Fetch dependencies | `freight fetch` |
| Build debug profile | `freight build` |
| Build release profile | `freight build --release` |
| Run tests | `freight test` |
| Run an executable | `freight run -- --help` |
| Inspect dependency tree | `freight tree` |
| Generate docs | `freight doc` |
| Install staged files | `freight install --prefix /usr/local --destdir target/stage` |
| Package artifacts | `freight package --target x86_64-linux-gnu,aarch64-linux-gnu` |
