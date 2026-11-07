# Publishing

The `Release` workflow runs on a pushed `vX.Y.Z` tag or a manual Actions run.
A manual version input or `[release X.Y.Z]` commit message can select a version;
otherwise it uses a newer manifest version or increments the latest tag. The
workflow updates the packaged manifest to match the release version.

Before packaging, it runs the official engine's modkit against the staged
release tree: `validate --strict --base fixture`, followed by `lint`. Any
finding stops publication. The archive is flat, with `manifest.json` and the
mod files at its root, and the release also includes SHA256 checksums. Import
the ZIP in game through **MODS > Import mod .zip**.

Johto uses a committed `.release/lib` snapshot of the shared first-person
library for standalone releases. When the workspace source is available, run
`python3 tools/sync_release_lib.py` after shared library changes and
`python3 tools/sync_release_lib.py --check` to verify it. The development `lib`
symlink stays pointed at the shared source.

Johto depends on the separately published voxel mod (`gmarcs_gen2_voxel_mod`);
install that dependency alongside this mod.
