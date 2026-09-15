# Opens the adjacent offline app; no administrator rights or remote code execution.
[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
$appPath = Join-Path $PSScriptRoot 'index.html'
if (-not (Test-Path -LiteralPath $appPath -PathType Leaf)) {
    throw 'index.html is missing. Extract the complete repository and try again.'
}
Start-Process -FilePath $appPath
