$password = ConvertTo-SecureString 'O2mi0r4bR4' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ('administrator', $password)

Invoke-Command -ComputerName 107.175.88.36 -Credential $cred -ScriptBlock {
    $runnerFolder = "C:\Github\actions-runner-blazortest001"
    Set-Location $runnerFolder

    Write-Host "=== Starting Runner in Background ===" -ForegroundColor Cyan

    # Start the runner as a background job
    Start-Job -ScriptBlock {
        Set-Location "C:\Github\actions-runner-blazortest001"
        & ".\run.cmd"
    }

    Start-Sleep -Seconds 5

    Write-Host "`n=== Checking Background Jobs ===" -ForegroundColor Cyan
    Get-Job | Select-Object Id, Name, State

    Write-Host "`n=== Runner should now be online at GitHub ===" -ForegroundColor Green
    Write-Host "Check: https://github.com/zillionresearch/BlazorTest001/settings/actions/runners" -ForegroundColor Cyan
}
