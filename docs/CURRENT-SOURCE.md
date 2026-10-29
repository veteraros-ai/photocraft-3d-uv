# PhotoCraft 0.17.0 source snapshot

The current 3D/UV source snapshot is based on upstream PhotoCraft commit
`5f9b4391874aabc9deb2fcb905267613e4d93ec8` and matches extension commit
`aed4caa4a754e9ffd42e1cd2709c8c92679acccd`. The cumulative source patch is
[`source/photocraft-uv-0.17.0.patch`](../source/photocraft-uv-0.17.0.patch).
Its SHA-256 is recorded in [`source/current-source.json`](../source/current-source.json).

Apply the patch to a clean checkout of the pinned upstream commit:

```powershell
git clone https://github.com/storytold/photocraft.git photocraft
git -C photocraft checkout 5f9b4391874aabc9deb2fcb905267613e4d93ec8
git -C photocraft apply ../source/photocraft-uv-0.17.0.patch
cargo build --manifest-path photocraft/Cargo.toml -p photocraft --features "heif uv-workbench" --release --locked
```

The Windows x64 portable ZIP contains the desktop and CLI executables, English
and Russian quick-start notes, notices, licenses (including the embedded UV icon
license), and a `portable.txt` marker. It is built from this exact patch by the
repository's **Build portable release** workflow. Extract the ZIP to a writable
folder and run `photocraft.exe`; it does not replace an installed PhotoCraft
executable. The current-source package is independent of the historical
reversible PhotoCraft 0.14.0 installer packages and their release assets.

## Screenshot provenance

The [workspace presentation](UV-WORKBENCH-0.17.0.md) shows the 0.17.0 source
build. The overview and mask-sublayer screenshots were updated for this release.
The PNG files are contributor-supplied originals; their SHA-256 digests and
attribution are listed in [`images/uv-showcase/README.md`](images/uv-showcase/README.md).

The older [`source/photocraft-uv-0.16.0.patch`](../source/photocraft-uv-0.16.0.patch)
and [`source/photocraft-uv.patch`](../source/photocraft-uv.patch) remain available
for the earlier 0.16.0 snapshot and historical PhotoCraft 0.14.0 installer
packages respectively. The `release-manifest.json` describes only the 0.14.0
installer packages.
