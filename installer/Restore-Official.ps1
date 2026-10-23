param([string]$InstallDirectory=(Join-Path $env:ProgramFiles 'PhotoCraft'))
. (Join-Path $PSScriptRoot 'Mod-Common.ps1')
$taskManifest=Read-ModManifest
$taskTarget=Get-ModTarget $InstallDirectory
$taskCurrent=Get-ModHash $taskTarget
if ($taskCurrent -eq $taskManifest.officialSha256) {Write-Host 'Official PhotoCraft is already installed.';exit 0}
if ($taskCurrent -ne $taskManifest.payloadSha256) {throw 'PhotoCraft was updated or modified since this mod was installed. Refusing to overwrite it with an older version.'}
$taskOfficial=Join-Path $PSScriptRoot ('Backups/official-'+$taskManifest.officialSha256+'.exe')
if (!(Test-Path -LiteralPath $taskOfficial) -or (Get-ModHash $taskOfficial) -ne $taskManifest.officialSha256) {throw 'A verified official backup was not found.'}
Set-ModExecutable $taskOfficial $taskTarget $taskManifest.officialSha256
@{schema=1;installed=$false;target=$taskTarget;restoredAt=(Get-Date).ToString('o')} | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $PSScriptRoot 'installed.json') -Encoding UTF8
Write-Host "Official PhotoCraft $($taskManifest.baseVersion) restored. Settings and projects are unchanged."
