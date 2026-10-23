param([string]$InstallDirectory=(Join-Path $env:ProgramFiles 'PhotoCraft'),[switch]$SkipShortcuts,[switch]$SkipSettingsBackup)
. (Join-Path $PSScriptRoot 'Mod-Common.ps1')
$taskManifest=Read-ModManifest
$taskTarget=Get-ModTarget $InstallDirectory
$taskPayload=Join-Path $PSScriptRoot 'payload/photocraft.exe'
if ((Get-ModHash $taskPayload) -ne $taskManifest.payloadSha256) {throw 'The mod payload is damaged. Extract the package again.'}
$taskBefore=Get-ModHash $taskTarget
if ($taskBefore -ne $taskManifest.officialSha256 -and $taskBefore -ne $taskManifest.payloadSha256) {
    $taskVersion=[Diagnostics.FileVersionInfo]::GetVersionInfo($taskTarget).ProductVersion
    throw "This package supports the official PhotoCraft $($taskManifest.baseVersion) only. Found version $taskVersion with an unknown hash. Nothing was replaced. A newer PhotoCraft requires a newly ported mod."
}
$taskBackupDir=Join-Path $PSScriptRoot 'Backups'
New-Item -ItemType Directory -Force -Path $taskBackupDir | Out-Null
$taskOfficial=Join-Path $taskBackupDir ('official-'+$taskManifest.officialSha256+'.exe')
if ($taskBefore -eq $taskManifest.officialSha256) {
    if (!(Test-Path -LiteralPath $taskOfficial)) {Copy-Item -LiteralPath $taskTarget -Destination $taskOfficial}
    if ((Get-ModHash $taskOfficial) -ne $taskManifest.officialSha256) {throw 'Official backup verification failed. Nothing was replaced.'}
} elseif (!(Test-Path -LiteralPath $taskOfficial) -or (Get-ModHash $taskOfficial) -ne $taskManifest.officialSha256) {
    throw 'The mod is installed but its official backup is missing. Restore this package Backups folder before reinstalling.'
}
if (!$SkipSettingsBackup) {Save-ModSettings}
if ($taskBefore -ne $taskManifest.payloadSha256) {Set-ModExecutable $taskPayload $taskTarget $taskManifest.payloadSha256}
if (!$SkipShortcuts) {Set-ModShortcuts $taskTarget}
@{schema=1;installed=$true;target=$taskTarget;baseVersion=$taskManifest.baseVersion;payloadSha256=$taskManifest.payloadSha256;officialSha256=$taskManifest.officialSha256;installedAt=(Get-Date).ToString('o')} | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $PSScriptRoot 'installed.json') -Encoding UTF8
Write-Host "PhotoCraft $($taskManifest.baseVersion) + 3D / UV installed: $taskTarget"
Write-Host 'Settings and project files have not been changed. Launch PhotoCraft normally.'
