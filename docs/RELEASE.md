# Release Guide

This file defines the release flow for `claude-skills---toumi`.

## First Release

```bash
git checkout main
git pull origin main
git add .
git commit -m "chore: release v0.1.0"
git push origin main
git tag -a v0.1.0 -m "v0.1.0"
git push origin v0.1.0
```

## Next Release

Replace `v0.1.1` with your next version.

```bash
git checkout main
git pull origin main
git add .
git commit -m "chore: release v0.1.1"
git push origin main
git tag -a v0.1.1 -m "v0.1.1"
git push origin v0.1.1
```

## Optional: GitHub Release Notes

After pushing a tag:

1. Open GitHub repo releases page.
2. Create release from the new tag.
3. Add short notes about changes.

## Install Commands For Users

Latest `main`:

```bash
tmp="$(mktemp -d)" && \
git clone --depth 1 --branch main git@github.com:toumiamine07/claude-skills---toumi.git "$tmp/toolkit" && \
"$tmp/toolkit/install.sh" --target "$PWD" && \
rm -rf "$tmp"
```

Pinned tag:

```bash
tmp="$(mktemp -d)" && \
git clone --depth 1 --branch v0.1.0 git@github.com:toumiamine07/claude-skills---toumi.git "$tmp/toolkit" && \
"$tmp/toolkit/install.sh" --target "$PWD" && \
rm -rf "$tmp"
```

## Versioning Suggestion

Use semantic versioning:

- patch: `v0.1.1` for docs/fixes/small changes
- minor: `v0.2.0` for new capabilities
- major: `v1.0.0` for breaking changes
