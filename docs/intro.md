---
id: intro
title: Freight ecosystem guide
slug: /
---

Freight is the build tool, package format, registry, documentation browser, and editor integration surface for native projects.

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

```bash
freight init hello
cd hello
freight build
freight run
```

The terminal demos are reproducible. See [Terminal demos](./terminal-demos.md) for the VHS tapes and text transcripts used in this guide.

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

Local builds usually stay in the `dev` profile until release validation:

```bash
freight check
freight fetch
freight build --time-passes
freight test
freight build --release
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

## Documentation

`freight doc` extracts source comments into a structured symbol index. Published docs appear in the package page through the source documentation viewer, while this guide covers the ecosystem workflow.

```bash
freight doc
freight doc --json
freight publish --registry https://registry.example.com
```

## Editor support

The editor extensions start `freight lsp` for `freight.toml` diagnostics, completion, hover, and source-language passthroughs. VS Code and Neovim wrappers live with the workspace; JetBrains support is planned.
