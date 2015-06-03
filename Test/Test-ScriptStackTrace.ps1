
& (Join-Path -Path $PSScriptRoot -ChildPath 'RivetTest\Import-RivetTest.ps1' -Resolve) 

function Start-Test
{
    Start-RivetTest
}

function Stop-Test
{
    Stop-RivetTest
}

function Test-ShouldDisplayScriptStackTrace
{
    $m = @'
function Push-Migration
{
    Add-Table -Name 'Foobar' -Column {
        Binary 'id' -TestingScriptStackTrace 'BogusString'
    } -Option 'data_compression = none'
}

function Pop-Migration
{
    Remove-Table 'Foobar'
}

'@ | New-Migration -Name 'BogusMigration'

    try
    {
        Invoke-Rivet -Push 'BogusMigration' -ErrorAction SilentlyContinue -ErrorVariable rivetError
        Assert-True ($rivetError.Count -gt 0)
        Assert-Like $rivetError[-1] 'TestingScriptStackTrace'
        Assert-Like $rivetError[-1] 'STACKTRACE'
    }
    finally
    {
        Remove-Item $m
    }
}