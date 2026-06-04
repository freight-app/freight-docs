---
id: dap-lsp
title: DAP and LSP
---

## DAP

`freight dap` is the editor-facing debug adapter entry point. It builds the current project when launching, selects a DAP-capable native debugger such as GDB or LLDB, and relays the Debug Adapter Protocol used by VS Code and other clients.

```bash
freight debug --launch-json
freight dap --config .vscode/freight-launch.json
freight dap --attach --config .vscode/freight-attach.json
freight dap --connect localhost:1234
```

Debugger arguments can come from `[debugger.gdb]` or `[debugger.lldb]` in `config.toml`, while launch-specific program arguments come from the editor launch configuration.

## LSP

`freight lsp` is a stdio language server for `freight.toml` plus a multiplexer for source-language servers. It provides manifest diagnostics, completion, hover text, signature help, path-dependency go-to-definition, and source-file passthroughs.

```bash
freight lsp --stdio
freight lsp --profile dev
freight lsp --no-clangd
freight lsp --no-fortls
freight lsp --no-asm-lsp
```

For C-family, Fortran, and assembly files, Freight refreshes a hidden `compile_commands.json` view from explicit manifest targets and dependency edges, then forwards source LSP traffic to `clangd`, `fortls`, or `asm-lsp`.
