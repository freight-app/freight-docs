---
id: freight-toml
title: freight.toml
---

`freight.toml` is the project contract. It describes package metadata, build targets, language settings, compiler options, features, and dependency edges that Freight resolves before compiling.

```toml
[package]
name = "hello"
version = "0.1.0"
edition = "2026"
license = "MIT"

[[bin]]
name = "hello"
src = "src/main.cpp"

[language.cpp]
std = "c++20"

[compiler]
backend = "clang"
warnings = "all"
defines = ["HELLO_USE_FAST_PATH"]
includes = ["include"]

[features]
default = ["tls"]
tls = ["dep:openssl"]

[dependencies]
fmt = "10"
openssl = { version = "3", optional = true }
local-core = { path = "../core" }
```

Base dependencies apply everywhere. `[build-dependencies]` are tools used during builds, and `[dev-dependencies]` are active only in debug/dev workflows.

Conditional sections are merged over the base manifest for the current target:

```toml
[os.linux.dependencies]
epoll-shim = "1"

[os.windows.dependencies]
winapi = "0.3"

[arch.x86_64.dependencies]
simd-core = { version = "2", features = ["avx2"] }
```

Detailed dependency entries can use `version`, `path`, `git`, `url`, `system`, `features`, `default-features`, `optional`, `os`, `arch`, `targets`, `type`, `include`, foreign build args, patches, `repo`, `channel`, and `unity` overrides.
