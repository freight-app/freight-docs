# Freight registry docs

The registry ecosystem guide is authored in Markdown in `docs-site/docs/`.
Docusaurus converts those files into the static site served by the registry.

```sh
bun install
bun run build
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
