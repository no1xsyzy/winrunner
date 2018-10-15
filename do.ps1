# set -e
$ErrorActionPreference = "Stop"
# script directory (like $~dp0 in batch)
# $PSCommandPath not used since not available in PS2
$dp0 = Split-Path -Parent $MyInvocation.MyCommand.Definition
Push-Location $dp0
# copy map
$cp = @{}
# config
$conf = @{}

# helper function to add default file extension
function Add-DefaultExtension ($Path, $Ext) {
    if ((Split-Path -Leaf $Path) -match "\.") {
        $Path
    }else{
        "${Path}.${Ext}"
    }
}

# rule recursive loader
function Load-Rules ($Path, $DirFrom, $DirTo) {
    Get-Content "$Path" | ForEach-Object {
        $line = $_
        switch($_[0]){
            `~ { # subdir
                $DirFrom = Join-Path -Path $DirFrom `
                                     -ChildPath $line.subString(1)
            }
            `! { # load other
                Load-Rules `
                    -Path (Add-DefaultExtension `
                        -Path (Join-Path `
                            -Path (Split-Path -Parent $Path) `
                            -ChildPath $line.subString(1)) `
                        -Ext "txt") `
                    -DirFrom $DirFrom `
                    -DirTo $DirTo `
            }
            Default { # bind to => from
                $tos, $from = $line -split "\|",2;
                $tos -split ";" | ForEach-Object {
                    $cp.Add((Join-Path $DirTo -ChildPath $_),
                            (Join-Path $DirFrom -ChildPath $from))
                }
            }
        }
    }
}

# load config
Get-Content "${dp0}\settings.conf" |
ForEach-Object {
    $k, $v = $_ -split "=",2
    if (($k -ne "") -and ($v -ne "")) {
        $conf.Add($k, $v)
    }
}

# load copy rules
Load-Rules -Path $conf["corerule"] -DirFrom $conf["from"] -DirTo $conf["to"]

# move old links
if (Test-Path $conf["to"]){
    $oldto = (Join-Path `
        -Path $conf["legacy"] `
        -ChildPath (Get-Date -UFormat "%Y/%m/%d/%H.%M.%S/"))
    # creates parents if not exists
    if(-not (Test-Path $oldto))
    {
        New-Item -Path $oldto -ItemType Directory -Force | Out-Null
    }
    # move them
    Move-Item `
        -LiteralPath $conf["to"] `
        -Destination $oldto
}

# do copy
New-Item -Path $conf["to"] -ItemType Directory -Force | Out-Null
foreach ($kvp in $cp.GetEnumerator()) {
    $to = $kvp.Key
    $from = $kvp.Value
    Copy-Item `
        -LiteralPath (Add-DefaultExtension -Path "$from" -Ext "lnk") `
        -Destination (Add-DefaultExtension -Path "$to"   -Ext "lnk") `
}

Pop-Location
