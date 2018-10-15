# set -e
$ErrorActionPreference = "Stop"
# script directory (like $~dp0 in batch)
# $PSCommandPath not used since not available in PS2
$dp0 = Split-Path -Parent $MyInvocation.MyCommand.Definition
Push-Location $dp0

# load config
$conf = @{}
Get-Content "${dp0}\settings.conf" |
ForEach-Object {
    $k, $v = $_ -split "=",2
    if (($k -ne "") -and ($v -ne "")) {
        $conf.Add($k, $v)
    }
}

# load old path
$oldpath = [Environment]::GetEnvironmentVariable("Path")

# link path
$link = Resolve-Path $conf["to"]

# generate new path
$patharr = $oldpath -split ";"
if($patharr -notcontains $link){
    $patharr += $link
}
$newpath = $patharr -join ";"

[Environment]::SetEnvironmentVariable("Path", $newpath, [EnvironmentVariableTarget]::Machine)

Pop-Location
