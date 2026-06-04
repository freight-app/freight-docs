---
id: dag
title: DAG build system
---

Freight treats packages, build stages, and C++20 module imports as directed acyclic graphs.

## Package stages

Dependency packages are topologically sorted so leaves build first. Independent packages in the same stage can build in parallel.

```bash
freight build --graph
freight build --graph --graph-format mermaid
freight build --graph --graph-format dot
```

The graph output is useful for checking why a package builds before another package and for rendering a Mermaid or Graphviz view in documentation.

## C++20 modules

For C++20 modules, Freight scans sources for `export module`, `module`, and `import`.

Module interface units are compiled in topological batches, then module implementation units and ordinary translation units compile after the required BMI files exist. Cycles are reported as module dependency errors instead of producing unstable build order.
