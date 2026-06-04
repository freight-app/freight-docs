---
id: terminal-demos
title: Terminal demos
---

Terminal examples are authored as reproducible scenarios:

- VHS `.tape` files render the animated demos used by the website.
- Matching shell scenarios are recorded with asciinema and rendered back to text transcripts for readers who prefer copyable output.

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
