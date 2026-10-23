# PhotoCraft 0.14.0 + 3D / UV

This is a standalone installation package for our 3D/UV extension, built for **official PhotoCraft 0.14.0, Windows x64**. It installs a compatible application build. PhotoCraft's current WASM plug-in API supports image filters; it cannot host the full 3D viewport, workspace interface and painting tools.

## Launching PhotoCraft

After installation, launch **PhotoCraft using its normal shortcut or ArtCraft Launcher**. You do not need to select a separate EXE. The launcher tracks the officially installed base version; 3D/UV is a local extension of that version.

The 3D/UV interface supports English and Russian and follows PhotoCraft's interface language preference. Choose **Edit > Preferences > Interface > Language > English** to use English. This English package includes an English README and installer messages. It does not overwrite your existing language or other preferences. In other interface languages, untranslated 3D/UV labels fall back to English.

## Installation and restore

1. Save your work and close PhotoCraft.
2. Install official PhotoCraft **0.14.0**.
3. Extract the entire package into a permanent folder, for example `D:\PhotoCraft-3D-UV`.
4. Run `Install-3D-UV.cmd`. If your PhotoCraft installation in Program Files requires administrator permissions, run this file as administrator.

To return to the official PhotoCraft build of the same version, run `Restore-Official.cmd`. Keep the `Backups` folder: it contains a verified copy of the original EXE. The installer does not terminate applications or delete projects.

The PowerShell scripts also accept `-InstallDirectory "full path to the PhotoCraft folder"`. Files are replaced only after SHA-256 verification. Before installation, preferences are backed up to a ZIP file in `Backups`; the originals are left unchanged.

Known previous 3D/UV builds can be upgraded directly. Keep the previous package: the installer finds its verified official EXE backup in adjacent PhotoCraft-3D-UV package folders, copies it into the new package, and also retains the previous mod EXE. If the old package is elsewhere, run `Install-Mod.ps1 -PreviousPackageDirectory "path to previous package"`. Without a verified official backup, installation stops before replacing the application. Unknown builds are still rejected even if their version number matches.

## Future updates through the launcher

The official installer may replace the main EXE. This package keeps an independent copy of the 3D build and its source patch, so the extension's files remain available.

- After repairing or reinstalling **the same official 0.14.0 release**, run `Install-3D-UV.cmd` again.
- A **different PhotoCraft release** requires a new package: the extension must be ported to that release's source, rebuilt and tested. This installer refuses unknown or newer executables to prevent an accidental downgrade.
- Do not manually overwrite a newer PhotoCraft release with an older 3D executable.

This is a version-specific application extension, not a universal binary plug-in for arbitrary future releases. The package makes installation and restoration reproducible and guards against accidental replacement of unsupported versions.

## Your data

Preferences, brushes and shortcuts remain in `%APPDATA%\Photocraft`. A `.pcuv` project contains the model, editable textures, layers, material bindings, environment settings and image library. `Export Textures` writes separate flattened images; saving the `.pcuv` file is sufficient to save the project.

## Source code

`source/photocraft-uv.patch` contains the extension relative to tag `v0.14.0` (`ff4738810134d7f7e68b49f2e4f231b686282ff3`). In a clean PhotoCraft checkout:

```text
git checkout v0.14.0
git apply photocraft-uv.patch
cargo build -p photocraft --features uv-workbench --release --locked
```

Our development build cache and temporary files are kept on drive D. PhotoCraft and additional icon licenses are included in `source/`.
