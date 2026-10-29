# PhotoCraft 3D / UV

[Русский](README.ru.md) · [Download Windows packages](https://github.com/veteraros-ai/photocraft-3d-uv/releases/latest)

A native 3D texture-painting and UV workspace for [PhotoCraft](https://github.com/storytold/photocraft), with an English and Russian interface. The current source targets PhotoCraft **0.17.0**; the reversible installer package is for **PhotoCraft 0.14.0 on Windows x64**.

This repository distributes the extension's source patch and reversible installer. The complete application is assembled from the pinned upstream release plus that patch. It is an independent community modification and is not an official PhotoCraft release.

The current source snapshot is ported to PhotoCraft **0.17.0**. Download its [Windows x64 portable ZIP (EN/RU)](https://github.com/veteraros-ai/photocraft-3d-uv/releases/tag/v0.17.0-uv.1). The reversible installer packages below remain for PhotoCraft 0.14.0. See [the 0.17.0 source and build notes](docs/CURRENT-SOURCE.md).

## Run the current PhotoCraft 0.17.0 portable build

1. Download the [EN or RU portable ZIP](https://github.com/veteraros-ai/photocraft-3d-uv/releases/tag/v0.17.0-uv.1) and extract the entire archive into a writable folder.
2. Run `photocraft.exe` from the extracted folder and choose the **3D** workspace.
3. To switch the interface, select **Edit > Preferences > Interface > Language**.

The portable marker keeps this build's settings and projects in `PhotoCraftData` beside the executable, separate from the installed PhotoCraft profile. The ZIP does not replace an installed executable. Keep the extracted folder together so PhotoCraft can find its command-line companion, notices, fonts and licenses.

## Showcase

These screenshots show the PhotoCraft 0.17.0 source build. [Open the full presentation](docs/UV-WORKBENCH-0.17.0.md) for more details and screenshot provenance.

### Workspace overview

![Textured model, UV texture and material maps](docs/images/uv-showcase/overview.png)

### Editable mask sublayers

![Paint, Fill, Levels and Blur mask sublayers](docs/images/uv-showcase/mask-sublayers.png)

### Polygon wireframe

![Dark and light polygon wireframe overlays](docs/images/uv-showcase/model-wireframe.png)

### Model selection

![UV shell and polygon selection on a model](docs/images/uv-showcase/model-selection.png)

## Features

- FBX (binary 7.4+) and OBJ import, material visibility, texture assignment and ReImport notifications.
- GPU 3D viewport with Maya-style navigation, perspective/orthographic projection, surface-based orbit pivots and combined 3D/2D layouts.
- Interactive UV shells, rectangle selection and editable seam margins in the texture editor.
- Native brush tools projected onto the model, Paint UV / Paint Wrap, clone sampling and eyedropper support.
- Material and unlit map views; Color, Normal, ID, AO, Curvature, Opacity, Metallic, Roughness and Emissive slots.
- Optional PBR lighting, HDR/EXR environment controls and layer-mask display on the model.
- A `.pcuv` project container for the model, layered texture documents, material bindings, scene settings, environment and image library. Separate **Export Textures** writes flattened maps.
- An isolated 3D workspace: ordinary PhotoCraft workspaces keep their own documents.

## Install the PhotoCraft 0.14.0 package

1. Install [official PhotoCraft 0.14.0](https://github.com/storytold/photocraft/releases/tag/v0.14.0), then close it after saving your work.
2. Download the **EN** or **RU** Windows ZIP from the [PhotoCraft 0.14.0 release](https://github.com/veteraros-ai/photocraft-3d-uv/releases/tag/v0.14.0-uv.3). Both packages contain the same bilingual application; the README language differs.
3. Extract the whole ZIP into a permanent folder and run `Install-3D-UV.cmd` as administrator when Program Files requires it.
4. Launch PhotoCraft using its normal shortcut or ArtCraft Launcher and choose the **3D** workspace.

Select **Edit > Preferences > Interface > Language > English** for English. Existing language and other preferences are preserved. Keep the package's `Backups` folder for `Restore-Official.cmd`.

Known previous 3D/UV builds upgrade directly when their verified official EXE backup is available in an adjacent package folder. Keep your previous package. If it is elsewhere, pass `-PreviousPackageDirectory "path to previous package"` to `Install-Mod.ps1`. The installer retains both the official EXE and previous mod EXE. Unknown builds are rejected even when the version number matches. A newer upstream PhotoCraft release requires a newly ported package.

[Full installation and restore guide](docs/INSTALL.en.md) · [Русская инструкция](docs/INSTALL.ru.md)

## Build the current PhotoCraft 0.17.0 source

The current patch applies to upstream commit `5f9b4391874aabc9deb2fcb905267613e4d93ec8` and produces source commit `aed4caa4a754e9ffd42e1cd2709c8c92679acccd`:

```powershell
git clone https://github.com/storytold/photocraft.git photocraft
git -C photocraft checkout 5f9b4391874aabc9deb2fcb905267613e4d93ec8
git -C photocraft apply ../source/photocraft-uv-0.17.0.patch
cargo build --manifest-path photocraft/Cargo.toml -p photocraft --features "heif uv-workbench" --release --locked
```

See [current source notes](docs/CURRENT-SOURCE.md) for portable package contents and scope. The Windows ZIP is built from this exact source snapshot by the repository's `Build portable release` workflow. This source build does not replace an installed PhotoCraft executable.

## Build the PhotoCraft 0.14.0 installer package

Install the Rust and Windows build prerequisites described by upstream. From this repository's root:

```powershell
git clone --depth 1 --branch v0.14.0 https://github.com/storytold/photocraft.git photocraft
git -C photocraft apply ../source/photocraft-uv.patch
cargo build --manifest-path photocraft/Cargo.toml -p photocraft --features uv-workbench --release --locked
```

The patch base is `ff4738810134d7f7e68b49f2e4f231b686282ff3`. Set `CARGO_TARGET_DIR` and `TEMP`/`TMP` to a drive with sufficient space before building. Source-build executables are local unsigned builds; the installer uses the hashes of the published binaries.

## Repository contents

- `source/photocraft-uv-0.17.0.patch`: current extension source, relative to upstream commit `5f9b439`.
- `source/photocraft-uv-0.16.0.patch`: previous PhotoCraft 0.16.0 source snapshot.
- `source/photocraft-uv.patch`: source patch used by the historical 0.14.0 installer packages.
- `installer/`: PowerShell installation and restore sources used in release packages.
- `docs/`: installation, implementation and validation notes.
- `release-manifest.json`: compatible base version and published payload/source hashes.

Prebuilt executables are release assets. User projects, preferences, commercial test models and build caches are not included.

## License and attribution

The upstream PhotoCraft code is available under MIT OR Apache-2.0; this source distribution preserves those terms. See [LICENSE-MIT](LICENSE-MIT), [LICENSE-APACHE](LICENSE-APACHE), [ATTRIBUTION.md](ATTRIBUTION.md) and [the UV icon license](source/LICENSE-uv-icons.txt). PhotoCraft and ArtCraft names and branding belong to their respective owners.
