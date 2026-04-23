Param(
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$RemainingArgs
)

# exec_command.ps1
# PowerShell wrapper: prefer Python exec_command if available, otherwise do best-effort expansions.
$scriptDir = Split-Path $MyInvocation.MyCommand.Path
$pyScript = Join-Path $scriptDir 'exec_command'

# Try python3 / python / py
$python = (Get-Command python3 -ErrorAction SilentlyContinue).Path
if (-not $python) { $python = (Get-Command python -ErrorAction SilentlyContinue).Path }
if (-not $python) { $python = (Get-Command py -ErrorAction SilentlyContinue).Path }

if ($python -and (Test-Path $pyScript)) {
    & $python $pyScript @RemainingArgs
    exit $LASTEXITCODE
}

if ($RemainingArgs.Count -lt 1) {
    Write-Error 'usage: exec_command.ps1 <command> [args]'
    exit 2
}

$cmd = $RemainingArgs[0]
$args = @()
for ($i = 1; $i -lt $RemainingArgs.Count; $i++) {
    $a = $RemainingArgs[$i]
    # expand ~ to user profile
    if ($a -like '~*') { $a = $a -replace '^~', $env:USERPROFILE }
    # expand environment variables like %VAR% or $env:VAR
    $a = [Environment]::ExpandEnvironmentVariables($a)

    # handle POSIX-like $(...) command substitution if the whole arg matches
    if ($a -match '^\$\((.*)\)$') {
        $inner = $Matches[1]
        try {
            # Try invoking the inner command directly (PowerShell will run executables like npm)
            $out = Invoke-Expression $inner
            $expanded = ($out -join "`n")
        } catch {
            $expanded = ''
        }
    } else {
        $expanded = $a
    }

    $args += $expanded
}

# Invoke the requested command with expanded args
& $cmd @args
exit $LASTEXITCODE
