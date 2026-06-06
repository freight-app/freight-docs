---
id: publish
title: Publish packages
---

Publishing sends the package manifest, source archive, README, and optional generated docs or prebuilts to the registry.

<img className="process-diagram" src="../img/diagrams/publish-registry.svg" alt="Freight publish and registry workflow diagram" />

```bash
freight login --registry https://registry.example.com
freight publish --registry https://registry.example.com
```

## What publish uploads

A publish operation is more than a file copy. Freight packages enough metadata for consumers, the registry UI, and editor/documentation tools:

| Item | Why it matters |
|---|---|
| `freight.toml` | Defines package metadata, dependency edges, features, and targets. |
| Source archive | Lets consumers build from source when no compatible prebuilt exists. |
| README | Provides registry/package page summary content. |
| Documentation index | Lets package pages and `freight doc` expose source documentation. |
| Optional prebuilts | Speeds up consumers on supported triples. |

Run tests and packaging locally before publishing:

```bash
freight fetch
freight test --release
freight package
freight publish --registry https://registry.example.com
```

Use channels for release lanes:

```bash
freight publish --registry https://registry.example.com --channel beta
```

Use owner management in the registry UI or API for packages maintained by more than one user or organization.

## Channels and consumers

Channels let one package carry several release lanes without changing its package name:

- `stable`: default consumer lane.
- `beta`: release candidates or limited-preview builds.
- `nightly`: fast-moving generated or CI-built artifacts.

Consumers can choose the channel in dependency declarations or registry configuration. Registry searches and package pages can show channel availability so users know whether they are consuming stable or preview releases.

## Registry-side storage

The registry can store source archives and README/docs content locally or in object storage, depending on deployment configuration. Consumers do not need to know the storage backend: `freight fetch` follows registry metadata and downloads into the project's `.pkgs/` cache.
