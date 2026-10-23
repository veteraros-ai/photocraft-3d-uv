# Validation: 2026-10-23

Base: official PhotoCraft v0.14.0, ff4738810134d7f7e68b49f2e4f231b686282ff3.

- 49 native 3D/UV UI tests passed; five manual benchmarks were ignored.
- All 53 localization tests passed, including catalog coverage.
- Native all-target Clippy with warnings denied passed.
- WebAssembly compilation check passed; five preexisting engine dead-code warnings remain.
- English and Russian offscreen workspace renders and the English image-library render were inspected.
- The cumulative patch applied to a clean v0.14.0 checkout; all 106 patched files matched the development source, and reverse-check passed.
- The optimized Windows Release build completed successfully. `--version` returns 0.14.0; its `dev build` suffix denotes local build metadata rather than a Debug profile.
- Release ZIP CRCs, manifest payload/patch hashes and README languages were verified.

Installer fixture coverage from the base-version port includes install/reinstall/restore, unknown-version rejection, corrupt-payload rejection and corrupt-backup rejection. Installation does not terminate running applications. The local installed application and original Russian archive were unchanged while the English distribution was prepared.

This is a tested local extension for the pinned release. Other upstream versions require a port and validation.

## Installer update: 2026.10.23.3

Eleven isolated Windows PowerShell scenarios passed: fresh install/reinstall/restore, known-build upgrade with adjacent backup discovery, explicit previous-package path, missing backup, corrupt discovered official backup, unknown executable, corrupt payload, corrupt own official backup, corrupt previous-mod backup, invalid previous hash and a legacy manifest without upgrade metadata. The real previous 0.14.0 mod also upgraded successfully; all thirteen settings files remained byte-identical and official/previous-mod backups were verified. The application payload and source patch are unchanged from the bilingual release.

Run the fixture checks on Windows with Python and Windows PowerShell:

```powershell
python tests/test_installer.py --scripts installer --workdir D:/PhotoCraft-installer-tests
```
