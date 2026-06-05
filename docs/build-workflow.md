---
id: build-workflow
title: Build workflow
---

Freight builds a project by turning `freight.toml` into a resolved package graph, a source inventory, and a set of compiler/linker jobs. The normal loop is:

```bash
freight check
freight fetch
freight build
freight test
freight run
```

`freight build` will fetch missing registry, Git, URL, path, and system dependencies as needed, but running `freight fetch` explicitly is useful in CI and when you want to verify dependency resolution before compiling.

## Project discovery

Commands can be run from any directory under a package. Freight walks up until it finds `freight.toml`. In a workspace, build/test/run commands can select one member with `-p`:

```bash
freight build -p mathlib
freight test -p mathlib
freight run -p app -- --input data/example.txt
```

The manifest decides which sources belong to the build:

- `[lib]` defines library sources and public headers.
- `[[bin]]` defines executable targets.
- Language sections such as `[language.cpp]` select standards and language behavior.
- `[compiler]` contributes shared backend, defines, includes, warnings, and flags.
- Feature and platform sections are merged for the selected build.

## Profiles and features

The default profile is `dev`. Use `--release` for optimized artifacts:

```bash
freight build
freight build --release
```

Feature flags activate optional dependency edges, defines, and build settings:

```bash
freight build --features tls,simd
freight build --no-default-features
freight test --features integration
```

Sanitizers can be enabled for local verification when the selected compiler supports them:

```bash
freight build --sanitize address,undefined
freight test --sanitize address
```

## What the build writes

Freight keeps downloaded package content and compiled artifacts separate:

- `.pkgs/<name>/` contains fetched dependency sources, prebuilts, metadata-only registry downloads, and local package cache state.
- `target/dev/` and `target/release/` contain compiled objects, libraries, and binaries.
- `target/deps/<name>/` contains source-built dependency artifacts that belong to the root build.
- `.freight/lsp/<profile>/compile_commands.json` is generated for clangd/editor integration.

`freight clean` removes `target/` but leaves `.pkgs/` intact so dependency downloads survive clean builds.

## Inspecting the build graph

Use graph output to see package and target order before compiling:

```bash
freight build --graph
freight build --graph --graph-format mermaid
freight build --graph --graph-format dot
```

For C++20 modules, Freight topologically sorts module interface units before compiling implementation units and ordinary translation units. Cycles are reported as module dependency errors.

## Timing and troubleshooting

When a build is slower than expected, print per-file timings:

```bash
freight build --time-passes
```

For IDE troubleshooting, regenerate the compile database through the CLI or editor command:

```bash
freight compile-commands
```

The VS Code extension runs build/debug tasks in the integrated terminal so compiler output, Freight progress, and problem matchers stay visible.
