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

<img className="process-diagram" src="/img/diagrams/build-workflow.svg" alt="Freight build workflow diagram" />

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

## Build stages

The build pipeline is intentionally split into stages so each stage can be inspected and reused by IDEs, package publishing, and CI:

1. **Load manifest**: find the package or workspace root and parse `freight.toml`.
2. **Resolve settings**: merge profile, target, feature, OS, architecture, compiler, and language sections.
3. **Fetch dependencies**: fill `.pkgs/` from registries, Git, URLs, path dependencies, or system packages.
4. **Resolve graph**: topologically order dependency packages and detect version or feature conflicts.
5. **Discover sources**: collect library sources, public headers, binaries, tests, benches, generated sources, and module units.
6. **Prepare toolchain**: select compiler templates and assemble include/link flags.
7. **Build dependencies**: build source dependencies into `target/deps/<name>/` when no compatible prebuilt is available.
8. **Compile package**: compile ordinary translation units, C++ module interfaces, implementation units, and generated sources.
9. **Link outputs**: produce libraries, binaries, tests, and benches under `target/<profile>/`.
10. **Emit metadata**: refresh `.freight/lsp/<profile>/compile_commands.json` for editor tooling.

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

| Path | Owner | Purpose |
|---|---|---|
| `.pkgs/` | fetch stage | Downloaded or unpacked dependency packages. |
| `.freight/lsp/<profile>/` | LSP stage | Editor-facing compile database and language-server metadata. |
| `target/dev/` | build stage | Debug-profile objects, libraries, and binaries. |
| `target/release/` | build stage | Release-profile objects, libraries, and binaries. |
| `target/deps/<name>/` | dependency source builds | Artifacts built from source dependencies for the root package. |
| `target/package/` | packaging | Archives, staged installs, and native installer outputs. |

## Inspecting the build graph

Use graph output to see package and target order before compiling:

```bash
freight build --graph
freight build --graph --graph-format mermaid
freight build --graph --graph-format dot
```

For C++20 modules, Freight topologically sorts module interface units before compiling implementation units and ordinary translation units. Cycles are reported as module dependency errors.

Graph output is useful in code review and CI logs because it explains ordering decisions without requiring a verbose build:

```bash
freight build --graph --graph-format mermaid > build-graph.mmd
freight build --graph --graph-format dot > build-graph.dot
```

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
