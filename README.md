# PhotoCraft 3D / UV

[Русский](README.ru.md) · [Download Windows packages](https://github.com/veteraros-ai/photocraft-3d-uv/releases/latest)

A native 3D texture-painting and UV workspace for [PhotoCraft](https://github.com/storytold/photocraft), built for **PhotoCraft 0.14.0 on Windows x64**. The workspace interface supports English and Russian.

This repository distributes the extension's source patch and reversible installer. The complete application is assembled from the pinned upstream release plus that patch. It is an independent community modification and is not an official PhotoCraft release.

## Features

- FBX (binary 7.4+) and OBJ import, material visibility, texture assignment and ReImport notifications.
- GPU 3D viewport with Maya-style navigation, perspective/orthographic projection, surface-based orbit pivots and combined 3D/2D layouts.
- Interactive UV shells, rectangle selection and editable seam margins in the texture editor.
- Native brush tools projected onto the model, Paint UV / Paint Wrap, clone sampling and eyedropper support.
- Material and unlit map views; Color, Normal, ID, AO, Curvature, Opacity, Metallic, Roughness and Emissive slots.
- Optional PBR lighting, HDR/EXR environment controls and layer-mask display on the model.
- A `.pcuv` project container for the model, layered texture documents, material bindings, scene settings, environment and image library. Separate **Export Textures** writes flattened maps.
- An isolated 3D workspace: ordinary PhotoCraft workspaces keep their own documents.

## Install

1. Install [official PhotoCraft 0.14.0](https://github.com/storytold/photocraft/releases/tag/v0.14.0), then close it after saving your work.
2. Download the **EN** or **RU** Windows ZIP from [Releases](https://github.com/veteraros-ai/photocraft-3d-uv/releases/latest). Both packages contain the same bilingual application; the README language differs.
3. Extract the whole ZIP into a permanent folder and run `Install-3D-UV.cmd` as administrator when Program Files requires it.
4. Launch PhotoCraft using its normal shortcut or ArtCraft Launcher and choose the **3D** workspace.

Select **Edit > Preferences > Interface > Language > English** for English. Existing language and other preferences are preserved. Keep the package's `Backups` folder for `Restore-Official.cmd`.

Known previous 3D/UV builds upgrade directly when their verified official EXE backup is available in an adjacent package folder. Keep your previous package. If it is elsewhere, pass `-PreviousPackageDirectory "path to previous package"` to `Install-Mod.ps1`. The installer retains both the official EXE and previous mod EXE. Unknown builds are rejected even when the version number matches. A newer upstream PhotoCraft release requires a newly ported package.

[Full installation and restore guide](docs/INSTALL.en.md) · [Русская инструкция](docs/INSTALL.ru.md)

## Build from source

Install the Rust and Windows build prerequisites described by upstream. From this repository's root:

```powershell
git clone --depth 1 --branch v0.14.0 https://github.com/storytold/photocraft.git photocraft
git -C photocraft apply ../source/photocraft-uv.patch
cargo build --manifest-path photocraft/Cargo.toml -p photocraft --features uv-workbench --release --locked
```

The patch base is `ff4738810134d7f7e68b49f2e4f231b686282ff3`. Set `CARGO_TARGET_DIR` and `TEMP`/`TMP` to a drive with sufficient space before building. Source-build executables are local unsigned builds; the installer uses the hashes of the published binaries.

## Repository contents

- `source/photocraft-uv.patch`: cumulative extension source, relative to upstream v0.14.0.
- `installer/`: PowerShell installation and restore sources used in release packages.
- `docs/`: installation, implementation and validation notes.
- `release-manifest.json`: compatible base version and published payload/source hashes.

Prebuilt executables are release assets. User projects, preferences, commercial test models and build caches are not included.

## License and attribution

The upstream PhotoCraft code is available under MIT OR Apache-2.0; this source distribution preserves those terms. See [LICENSE-MIT](LICENSE-MIT), [LICENSE-APACHE](LICENSE-APACHE), [ATTRIBUTION.md](ATTRIBUTION.md) and [the UV icon license](source/LICENSE-uv-icons.txt). PhotoCraft and ArtCraft names and branding belong to their respective owners.
