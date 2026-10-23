# PhotoCraft 3D/UV: version-pinned, reversible installation. No process is terminated.
$ErrorActionPreference='Stop'
function Read-ModManifest {
    $taskManifest=Get-Content -LiteralPath (Join-Path $PSScriptRoot 'manifest.json') -Raw -Encoding UTF8 | ConvertFrom-Json
    if ($taskManifest.schema -ne 1 -or $taskManifest.baseVersion -notmatch '^\d+\.\d+\.\d+$') {throw 'Invalid mod manifest.'}
    foreach ($taskHash in @($taskManifest.payloadSha256,$taskManifest.officialSha256)) {
        if ($taskHash -notmatch '^[0-9a-fA-F]{64}$') {throw 'Invalid executable hash in manifest.'}
    }
    return $taskManifest
}
function Get-ModHash([string]$Path) {
    $taskStream=[IO.File]::OpenRead($Path)
    $taskHasher=[Security.Cryptography.SHA256]::Create()
    try {return [BitConverter]::ToString($taskHasher.ComputeHash($taskStream)).Replace('-','').ToLowerInvariant()}
    finally {$taskHasher.Dispose();$taskStream.Dispose()}
}
function Get-ModTarget([string]$Directory) {
    $taskDirectory=[IO.Path]::GetFullPath($Directory)
    $taskTarget=[IO.Path]::GetFullPath((Join-Path $taskDirectory 'photocraft.exe'))
    if (![IO.Path]::GetDirectoryName($taskTarget).Equals($taskDirectory.TrimEnd('\','/'),[StringComparison]::OrdinalIgnoreCase)) {throw 'Invalid installation directory.'}
    if (!(Test-Path -LiteralPath $taskTarget -PathType Leaf)) {throw 'Install the supported official PhotoCraft first: photocraft.exe was not found.'}
    foreach ($taskProcess in @(Get-Process -Name photocraft -ErrorAction SilentlyContinue)) {
        $taskProcessPath=$null
        try {$taskProcessPath=$taskProcess.Path} catch {throw 'Cannot verify the running PhotoCraft. Close PhotoCraft before installing the mod.'}
        if (!$taskProcessPath -or $taskProcessPath.Equals($taskTarget,[StringComparison]::OrdinalIgnoreCase)) {throw 'Close PhotoCraft before installing or removing the mod. Your work has not been closed.'}
    }
    return $taskTarget
}
function Set-ModExecutable([string]$Source,[string]$Target,[string]$Hash) {
    if ((Get-ModHash $Source) -ne $Hash) {throw 'Source executable hash verification failed.'}
    $taskStaging=$Target+'.uv-new-'+[guid]::NewGuid().ToString('N')
    $taskPrevious=$Target+'.uv-previous-'+[guid]::NewGuid().ToString('N')
    try {
        Copy-Item -LiteralPath $Source -Destination $taskStaging -ErrorAction Stop
        if ((Get-ModHash $taskStaging) -ne $Hash) {throw 'Staged executable hash verification failed.'}
        [IO.File]::Replace($taskStaging,$Target,$taskPrevious)
        if ((Get-ModHash $Target) -ne $Hash) {throw 'Installed executable hash verification failed.'}
        Remove-Item -LiteralPath $taskPrevious -Force
    } finally {
        if (Test-Path -LiteralPath $taskStaging) {Remove-Item -LiteralPath $taskStaging -Force}
    }
}
function Save-ModSettings {
    $taskSettings=Join-Path $env:APPDATA 'Photocraft'
    if (!(Test-Path -LiteralPath $taskSettings)) {return}
    Add-Type -AssemblyName System.IO.Compression
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $taskBackupDir=Join-Path $PSScriptRoot 'Backups'
    New-Item -ItemType Directory -Force -Path $taskBackupDir | Out-Null
    $taskZipPath=Join-Path $taskBackupDir ('settings-'+(Get-Date -Format 'yyyyMMdd-HHmmss')+'-'+[guid]::NewGuid().ToString('N').Substring(0,6)+'.zip')
    $taskZip=[IO.Compression.ZipFile]::Open($taskZipPath,[IO.Compression.ZipArchiveMode]::Create)
    try {
        foreach ($taskFile in Get-ChildItem -LiteralPath $taskSettings -Recurse -File) {
            $taskRelative=$taskFile.FullName.Substring($taskSettings.Length).TrimStart('\','/')
            if ($taskRelative -match '(^|[\\/])Recovery([\\/]|$)') {continue}
            [IO.Compression.ZipFileExtensions]::CreateEntryFromFile($taskZip,$taskFile.FullName,$taskRelative,[IO.Compression.CompressionLevel]::Optimal) | Out-Null
        }
    } finally {$taskZip.Dispose()}
}
function Set-ModShortcuts([string]$Target) {
    $taskShell=New-Object -ComObject WScript.Shell
    $taskMenu=Join-Path $env:APPDATA 'Microsoft/Windows/Start Menu/Programs/PhotoCraft.lnk'
    $taskCommonMenu=Join-Path $env:ProgramData 'Microsoft/Windows/Start Menu/Programs/PhotoCraft.lnk'
    $taskDesktop=Join-Path ([Environment]::GetFolderPath('Desktop')) 'PhotoCraft.lnk'
    $taskCommonDesktop=Join-Path ([Environment]::GetFolderPath('CommonDesktopDirectory')) 'PhotoCraft.lnk'
    $taskPinned=Join-Path $env:APPDATA 'Microsoft/Internet Explorer/Quick Launch/User Pinned/TaskBar/PhotoCraft.lnk'
    # A fresh direct shortcut avoids MSI advertised-link repair restoring the official EXE.
    $taskBackupDir=Join-Path $PSScriptRoot 'Backups'
    New-Item -ItemType Directory -Force -Path $taskBackupDir | Out-Null
    $taskDirect=Join-Path $taskBackupDir 'PhotoCraft-direct.lnk'
    $taskLink=$taskShell.CreateShortcut($taskDirect)
    $taskLink.TargetPath=$Target
    $taskLink.Arguments=''
    $taskLink.WorkingDirectory=Split-Path -Parent $Target
    $taskLink.IconLocation=$Target+',0'
    $taskLink.Description='PhotoCraft'
    $taskLink.Save()
    foreach ($taskPath in @($taskMenu,$taskCommonMenu,$taskDesktop,$taskCommonDesktop,$taskPinned)) {
        if ($taskPath -ne $taskMenu -and !(Test-Path -LiteralPath $taskPath)) {continue}
        New-Item -ItemType Directory -Force -Path (Split-Path -Parent $taskPath) | Out-Null
        if (Test-Path -LiteralPath $taskPath) {
            $taskOldLink=Join-Path $taskBackupDir ('shortcut-'+(Get-ModHash $taskPath)+'.lnk')
            if (!(Test-Path -LiteralPath $taskOldLink)) {Copy-Item -LiteralPath $taskPath -Destination $taskOldLink}
        }
        Copy-Item -LiteralPath $taskDirect -Destination $taskPath -Force
    }
}
