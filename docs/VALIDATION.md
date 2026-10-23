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
