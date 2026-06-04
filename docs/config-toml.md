---
id: config-toml
title: config.toml
---

`config.toml` is machine-local configuration. Freight loads system defaults, then user defaults, then project-local overrides.

```toml
# /etc/freight/config.toml
# ~/.freight/config.toml
# <project>/.freight/config.toml

default_backend = "clang"
default_debugger = "lldb"
target = "aarch64-linux-gnu"
sysroot = "/opt/sysroots/aarch64"
auto-cpu-tuning = true

[[registries]]
name = ""
url = "https://registry.example.com"

[[registries]]
name = "internal"
url = "https://freight.company.example"

[debugger.gdb]
args = ["--quiet"]

[debugger.lldb]
args = ["--source", ".lldbinit"]
```

Project-local config is useful for team registry URLs, target triples, sysroots, and debugger defaults that should not be committed into `freight.toml`.

Tokens are loaded from credentials storage or environment, not displayed in account settings.
