---
id: install-package
title: Install and package
---

Freight has two related release workflows:

- `freight install` copies build outputs into an install prefix such as `/usr/local`.
- `freight package` builds a staged install tree and archives it for distribution.

## Install to a prefix

Install a release build to the default prefix:

```bash
freight install
```

Choose a prefix when installing into a local toolchain or project sandbox:

```bash
freight install --prefix "$HOME/.local"
```

Use `--destdir` for package-manager staging. The final files are installed under `DESTDIR + prefix`:

```bash
freight install --prefix /usr/local --destdir target/stage
```

Skip the build step when the current `target/` output is already correct:

```bash
freight build --release
freight install --no-build --prefix /usr/local --destdir target/stage
```

Freight installs executable targets to `bin/`, libraries to `lib/`, and public headers to `include/` based on the package manifest and produced build artifacts.

## Build archives

Create a native release archive:

```bash
freight package
```

The archive is written under `target/package/` and named with package, version, architecture, and operating system.

Build multiple target archives by passing target triples:

```bash
freight package --target x86_64-linux-gnu,aarch64-linux-gnu
```

Unsupported target combinations are skipped with warnings so CI can request a matrix without failing the entire packaging job when one target is unavailable on the current runner.

## Native installers

Use `--installer` when you want a platform installer instead of a plain archive:

```bash
freight package --installer
```

Installer output is host-specific:

- Linux: `.deb`
- macOS: `.dmg`
- Windows: NSIS `.exe`

Platform installer generation depends on host tools such as `dpkg-deb`, `hdiutil`, or `makensis`.

## CI release shape

A typical release job does the same operations locally:

```bash
freight fetch
freight test --release
freight package --target x86_64-linux-gnu,aarch64-linux-gnu
```

Publish only after the package artifacts are created and verified:

```bash
freight login --registry https://registry.example.com
freight publish --registry https://registry.example.com
```

Use `freight install --destdir` when producing distro packages, and use `freight package` when you want Freight's built-in archive/installer layout.
