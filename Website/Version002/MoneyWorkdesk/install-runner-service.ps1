# Install and Start GitHub Actions Runner Service

$password = ConvertTo-SecureString 'O2mi0r4bR4' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ('administrator', $password)

Invoke-Command -ComputerName 107.175.88.36 -Credential $cred -ScriptBlock {
    $runnerFolder = "C:\Github\actions-runner-blazortest001"
    Set-Location $runnerFolder

    Write-Host "=== Installing Runner as Windows Service ===" -ForegroundColor Cyan
    & ".\svc.cmd" install

    Write-Host "`n=== Starting Service ===" -ForegroundColor Cyan
    & ".\svc.cmd" start

    Start-Sleep -Seconds 3

    Write-Host "`n=== Checking Service Status ===" -ForegroundColor Cyan
    & ".\svc.cmd" status

    Write-Host "`n=== Verifying via Windows Services ===" -ForegroundColor Cyan
    Get-Service -Name "actions.runner.*" | Select-Object Name, Status, StartType
}
