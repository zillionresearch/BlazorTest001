$password = ConvertTo-SecureString 'O2mi0r4bR4' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ('administrator', $password)

Invoke-Command -ComputerName 107.175.88.36 -Credential $cred -ScriptBlock {
    $runnerFolder = "C:\Github\actions-runner-blazortest001"
    Set-Location $runnerFolder

    Write-Host "=== Installing Runner Service Using PowerShell ===" -ForegroundColor Cyan

    # The correct way to install on Windows
    & "$runnerFolder\config.cmd" install-service

    Write-Host "`n=== Starting Service ===" -ForegroundColor Cyan
    Start-Service "actions.runner.*"

    Start-Sleep -Seconds 5

    Write-Host "`n=== Service Status ===" -ForegroundColor Cyan
    Get-Service -Name "actions.runner.*" | Select-Object Name, Status, StartType | Format-Table -AutoSize
}
