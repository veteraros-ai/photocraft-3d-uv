param([string]$InstallDirectory=(Join-Path $env:ProgramFiles 'PhotoCraft'),[string]$PreviousPackageDirectory,[switch]$SkipShortcuts,[switch]$SkipSettingsBackup)
. (Join-Path $PSScriptRoot 'Mod-Common.ps1')
$taskManifest=Read-ModManifest
$taskTarget=Get-ModTarget $InstallDirectory
$taskPayload=Join-Path $PSScriptRoot 'payload/photocraft.exe'
if ((Get-ModHash $taskPayload) -ne $taskManifest.payloadSha256) {throw 'The mod payload is damaged. Extract the package again.'}
$taskBefore=Get-ModHash $taskTarget
$taskKnownPrevious=@($taskManifest.previousPayloadSha256) -contains $taskBefore
if ($taskBefore -ne $taskManifest.officialSha256 -and $taskBefore -ne $taskManifest.payloadSha256 -and !$taskKnownPrevious) {
    $taskVersion=[Diagnostics.FileVersionInfo]::GetVersionInfo($taskTarget).ProductVersion
    throw "Unsupported PhotoCraft executable: version $taskVersion, SHA-256 $taskBefore. This package accepts official PhotoCraft $($taskManifest.baseVersion) and listed previous 3D/UV builds only. Nothing was replaced."
}
$taskBackupDir=Join-Path $PSScriptRoot 'Backups'
New-Item -ItemType Directory -Force -Path $taskBackupDir | Out-Null
$taskOfficial=Join-Path $taskBackupDir ('official-'+$taskManifest.officialSha256+'.exe')
if ($taskBefore -eq $taskManifest.officialSha256) {
    if (!(Test-Path -LiteralPath $taskOfficial)) {Copy-Item -LiteralPath $taskTarget -Destination $taskOfficial}
    if ((Get-ModHash $taskOfficial) -ne $taskManifest.officialSha256) {throw 'Official backup verification failed. Nothing was replaced.'}
} else {
    if (Test-Path -LiteralPath $taskOfficial) {
        if ((Get-ModHash $taskOfficial) -ne $taskManifest.officialSha256) {throw 'Official backup verification failed. Nothing was replaced.'}
    } else {
        $taskPreviousOfficial=Find-ModOfficialBackup $PreviousPackageDirectory $taskManifest.officialSha256 $taskManifest.baseVersion
        if (!$taskPreviousOfficial) {
            throw 'The installed 3D/UV build is recognized, but its verified official backup was not found. Keep the previous package and run Install-Mod.ps1 -PreviousPackageDirectory "path to previous package". Nothing was replaced.'
        }
        Copy-Item -LiteralPath $taskPreviousOfficial -Destination $taskOfficial
        if ((Get-ModHash $taskOfficial) -ne $taskManifest.officialSha256) {throw 'Copied official backup verification failed. Nothing was replaced.'}
    }
    if ($taskKnownPrevious -and $taskBefore -ne $taskManifest.payloadSha256) {
        $taskPreviousMod=Join-Path $taskBackupDir ('mod-'+$taskBefore+'.exe')
        if (!(Test-Path -LiteralPath $taskPreviousMod)) {Copy-Item -LiteralPath $taskTarget -Destination $taskPreviousMod}
        if ((Get-ModHash $taskPreviousMod) -ne $taskBefore) {throw 'Previous mod backup verification failed. Nothing was replaced.'}
        Write-Host 'Upgrading a verified previous 3D/UV build; official and previous-build backups retained.'
    }
}
if (!$SkipSettingsBackup) {Save-ModSettings}
if ($taskBefore -ne $taskManifest.payloadSha256) {Set-ModExecutable $taskPayload $taskTarget $taskManifest.payloadSha256}
if (!$SkipShortcuts) {Set-ModShortcuts $taskTarget}
@{schema=1;installed=$true;target=$taskTarget;baseVersion=$taskManifest.baseVersion;payloadSha256=$taskManifest.payloadSha256;officialSha256=$taskManifest.officialSha256;installedAt=(Get-Date).ToString('o')} | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $PSScriptRoot 'installed.json') -Encoding UTF8
Write-Host "PhotoCraft $($taskManifest.baseVersion) + 3D / UV installed: $taskTarget"
Write-Host 'Settings and project files have not been changed. Launch PhotoCraft normally.'
