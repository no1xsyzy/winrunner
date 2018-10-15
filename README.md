# winrunner

Win+Run with (extremely) shortened names.

## Prerequisites

* Windows (Later than 7)
* [PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/powershell-scripting) (Windows 7 has already included it)

## Installation

1. Get a copy of this repository. Two ways in general:
    1. Download the [zip archieve](https://github.com/no1xsyzy/winrunner/archive/master.zip)
    2. (Another way if you have git) `git clone https://github.com/no1xsyzy/winrunner.git`
2. Configure `settings.conf`. Entries explained:
    1. `corerule`: absolute or relative path to the core rule file (explained below)
    2. `from`: contains links with friendly long name
    3. `to`: will contain links with short name
    4. `legacy`: old link files with short name, kept in case
3. Put your `.lnk` files to the path configured as `from`
4. Configure rule files to point to your lnk files.
5. Allow PowerShell to execute scripts.
    1. Open PowerShell with Administrator
    2. Type `Set-ExecutionPolicy RemoteSigned` and enter.
6. Add the path configured as `to` in environment `path`. Two ways:
		1. Run `addPath.ps1` as Administrator
		2. Edit with System Properties dialog
7. Run `do.ps1`
8. Enjoy the amazing speed

## Rule file

### Core rule file

The core rule file is the main entry of all rule files is required in it.

### Syntax of rule files

* `~` will change the source destination (relative to current destination). It will persist in one file.
* `!` will include another file.
* otherwise, `|` will split shortened name and long name. It is possible to add several shortened name splitted with `;`

## Contributing

For bugs & feature requests, just raise issue.
If you would like to work on that, start a PR and mark as `[WIP]` (to tell others it has been working on).
