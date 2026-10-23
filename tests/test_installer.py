"""Isolated Windows PowerShell installer regressions; never touches the real app."""
from pathlib import Path
import argparse
import hashlib
import json
import os
import shutil
import subprocess
import uuid

parser = argparse.ArgumentParser()
parser.add_argument('--scripts', type=Path, default=Path(__file__).resolve().parent)
parser.add_argument('--workdir', type=Path, required=True, help='Non-system scratch directory')
args = parser.parse_args()
storage = args.workdir.resolve() / ('installer-upgrade-' + uuid.uuid4().hex[:8])
storage.mkdir(parents=True)
official, previous, current = b'official-fixture', b'previous-fixture', b'current-fixture'
sha = lambda data: hashlib.sha256(data).hexdigest()

def fixture(name, installed, **changes):
    base = storage / name
    package, target = base / 'PhotoCraft-3D-UV-new', base / 'app'
    (package / 'payload').mkdir(parents=True)
    target.mkdir()
    for source in args.scripts.glob('*.ps1'):
        shutil.copy2(source, package / source.name)
    (package / 'payload/photocraft.exe').write_bytes(current)
    (target / 'photocraft.exe').write_bytes(installed)
    manifest = dict(schema=1, baseVersion='0.14.0', payloadSha256=sha(current),
                    officialSha256=sha(official), previousPayloadSha256=[sha(previous)])
    manifest.update(changes)
    (package / 'manifest.json').write_text(json.dumps(manifest), encoding='utf-8')
    return base, package, target

def backup(package, content=official):
    path = package / 'Backups' / ('official-' + sha(official) + '.exe')
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(content)
    return path

def run(package, target, succeed=True, restore=False, extra=()):
    command = ['powershell.exe', '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File',
               str(package / ('Restore-Official.ps1' if restore else 'Install-Mod.ps1')),
               '-InstallDirectory', str(target)]
    if not restore:
        command += ['-SkipShortcuts', '-SkipSettingsBackup']
    environment = os.environ.copy()
    environment['TEMP'] = environment['TMP'] = str(storage)
    result = subprocess.run(command + list(extra), capture_output=True, text=True,
                            encoding='utf-8', errors='replace', env=environment)
    assert (result.returncode == 0) == succeed, result.stdout + result.stderr
    return result

base, package, target = fixture('fresh', official)
run(package, target)
assert (target / 'photocraft.exe').read_bytes() == current
assert (package / 'Backups' / ('official-' + sha(official) + '.exe')).read_bytes() == official
run(package, target)
run(package, target, restore=True)
assert (target / 'photocraft.exe').read_bytes() == official

base, package, target = fixture('upgrade-auto', previous)
old = base / 'PhotoCraft-3D-UV-old' / '0.14.0'
backup(old)
run(package, target)
assert (target / 'photocraft.exe').read_bytes() == current
assert (package / 'Backups' / ('mod-' + sha(previous) + '.exe')).read_bytes() == previous
run(package, target, restore=True)
assert (target / 'photocraft.exe').read_bytes() == official
assert (old / 'Backups' / ('official-' + sha(official) + '.exe')).read_bytes() == official

base, package, target = fixture('upgrade-explicit', previous)
old = storage / 'unrelated-archive-location'
backup(old)
run(package, target, extra=['-PreviousPackageDirectory', str(old)])
assert (target / 'photocraft.exe').read_bytes() == current

base, package, target = fixture('missing-backup', previous)
run(package, target, succeed=False)
assert (target / 'photocraft.exe').read_bytes() == previous

base, package, target = fixture('corrupt-discovered-backup', previous)
backup(base / 'PhotoCraft-3D-UV-old', b'corrupt')
run(package, target, succeed=False)
assert (target / 'photocraft.exe').read_bytes() == previous

base, package, target = fixture('unknown', b'unknown-build')
backup(base / 'PhotoCraft-3D-UV-old')
run(package, target, succeed=False)
assert (target / 'photocraft.exe').read_bytes() == b'unknown-build'

base, package, target = fixture('corrupt-payload', official)
(package / 'payload/photocraft.exe').write_bytes(b'corrupt')
run(package, target, succeed=False)
assert (target / 'photocraft.exe').read_bytes() == official

base, package, target = fixture('corrupt-own-backup', current)
backup(package, b'corrupt')
run(package, target, succeed=False)
assert (target / 'photocraft.exe').read_bytes() == current

base, package, target = fixture('corrupt-previous-mod-backup', previous)
backup(package)
(package / 'Backups' / ('mod-' + sha(previous) + '.exe')).write_bytes(b'corrupt')
run(package, target, succeed=False)
assert (target / 'photocraft.exe').read_bytes() == previous

base, package, target = fixture('invalid-previous-hash', previous, previousPayloadSha256=['invalid'])
run(package, target, succeed=False)
assert (target / 'photocraft.exe').read_bytes() == previous

base, package, target = fixture('legacy-manifest', official)
manifest_path = package / 'manifest.json'
manifest = json.loads(manifest_path.read_text())
del manifest['previousPayloadSha256']
manifest_path.write_text(json.dumps(manifest))
run(package, target)
assert (target / 'photocraft.exe').read_bytes() == current
print('PASS: 11 installer scenarios, including verified upgrade and official restore.')
print('Fixtures: ' + str(storage))
