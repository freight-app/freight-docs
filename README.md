# Freight registry docs

The Freight ecosystem guide is authored in Markdown in `docs/`.
Docusaurus converts those files into the static site published with GitHub Pages.

```sh
bun install
bun run build
```

Terminal examples are generated from VHS tapes and asciinema scenarios:

```sh
bun run examples:terminal
```

The build output is written to `build/` and published through GitHub Pages.

Public site:

```text
https://freight-app.github.io/freight-docs/
```

Edit these files for content changes:

- `docs/intro.md`
- `docs/install.md`
- `docs/freight-toml.md`
- `docs/config-toml.md`
- `docs/dap-lsp.md`
- `docs/dag.md`
- `docs/publish.md`

Edit `sidebars.js` for navigation changes.
