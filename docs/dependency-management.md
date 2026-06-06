---
id: dependency-management
title: Dependency management
---

Freight dependency management is manifest-first: dependency edges live in `freight.toml`, and the resolved packages are fetched into the project-local `.pkgs/` cache.

<img className="process-diagram" src="../img/diagrams/dependency-resolution.svg" alt="Freight dependency resolution diagram" />

## Adding and removing packages

Use the CLI when the dependency should be edited into the manifest:

```bash
freight add fmt@10
freight add openssl
freight add mathlib --path ../mathlib
freight remove openssl
```

Run `freight fetch` to populate `.pkgs/` without compiling:

```bash
freight fetch
freight tree
freight outdated
freight update fmt
```

The package cache is intentionally separate from build output. This makes `freight clean` cheap and keeps registry/Git/URL downloads available for later builds.

## Resolution model

Freight resolves dependencies from the root project outward:

1. Read the base dependency tables from the current package or selected workspace member.
2. Merge active feature edges, including `dep:<name>` optional dependency activations.
3. Merge target-specific dependency tables such as `[os.windows.dependencies]` and `[arch.x86_64.dependencies]`.
4. Resolve registry versions and channels, local path manifests, Git refs, URL archives, and system packages.
5. Build a package graph that records direct and transitive dependencies, feature unions, and source/prebuilt decisions.
6. Fetch missing packages into `.pkgs/` before compilation begins.

This is why `freight fetch` is a useful standalone command: it exercises dependency resolution and cache population without compiling sources.

## Dependency scopes

Base dependencies apply to normal builds:

```toml
[dependencies]
fmt = "10"
zlib = "1"
```

Build dependencies are tools needed during compilation. Freight builds or fetches them first and prepends their `bin/` directories to `PATH` for later build stages:

```toml
[build-dependencies]
codegen = { path = "../tools/codegen" }
```

Dev dependencies are for local development and test workflows:

```toml
[dev-dependencies]
testkit = "0.4"
```

| Scope | Manifest table | Active during |
|---|---|---|
| Runtime/build dependency | `[dependencies]` | Normal package builds, tests, runs, installs, and packages. |
| Build tool | `[build-dependencies]` | Build scripts, generated code, preprocessors, and tools needed before compile. |
| Development dependency | `[dev-dependencies]` | Tests, benches, examples, and local development workflows. |
| Platform dependency | `[os.*.dependencies]`, `[arch.*.dependencies]` | Only when the selected target matches. |

## Dependency sources

Registry packages use a version requirement:

```toml
[dependencies]
fmt = "10"
```

Path dependencies are best for monorepos and local development:

```toml
[dependencies.mathlib]
path = "../mathlib"
```

Git and URL dependencies let a project pin external source:

```toml
[dependencies.netlib]
git = "https://github.com/example/netlib.git"
tag = "v1.2.0"

[dependencies.geom]
url = "https://example.com/geom-0.3.0.tar.gz"
version = "0.3"
```

System dependencies declare that the package comes from the host platform rather than Freight's registry cache:

```toml
[dependencies]
openssl = { system = true, version = "3" }
```

Use path dependencies for active monorepo development. Use Git or URL dependencies when an upstream is not published to a Freight registry. Use registry dependencies when you want repeatable version selection, package ownership, channels, uploaded docs, and prebuilts.

## Features and optional dependencies

Optional dependencies are activated by features:

```toml
[features]
default = ["tls"]
tls = ["dep:openssl"]
simd = []

[dependencies]
openssl = { version = "3", optional = true }
```

Then choose features per command:

```bash
freight build --features tls,simd
freight test --no-default-features
```

## Platform-specific dependencies

Conditional dependency sections are merged for the selected target:

```toml
[os.linux.dependencies]
epoll-shim = "1"

[os.windows.dependencies]
winapi = "0.3"

[arch.x86_64.dependencies]
simd-core = { version = "2", features = ["avx2"] }
```

Use this for operating-system libraries, compiler-specific packages, and architecture-specific acceleration.

Platform sections compose with features. A dependency can be optional and platform-specific when a feature should enable it only on matching targets.

## Prebuilts and source builds

Freight prefers a compatible prebuilt when one is available for the selected target. If a package is metadata-only or no compatible prebuilt exists, Freight can fetch source and build the dependency before compiling the current package.

Transitive dependency source builds reuse the root project's flat `.pkgs/` pool and place compiled artifacts under `target/deps/<name>/`, which avoids nested dependency caches.

## Practical checks

Use these commands when changing dependencies:

```bash
freight check
freight fetch
freight tree
freight outdated
freight build --graph
```

`freight tree` answers "what did I depend on?", while `freight build --graph` answers "what will build first?".
