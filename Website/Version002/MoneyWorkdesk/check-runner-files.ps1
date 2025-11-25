$password = ConvertTo-SecureString 'O2mi0r4bR4' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ('administrator', $password)

Invoke-Command -ComputerName 107.175.88.36 -Credential $cred -ScriptBlock {
    $runnerFolder = "C:\Github\actions-runner-blazortest001"
    Write-Host "=== Files in Runner Folder ===" -ForegroundColor Cyan
    Get-ChildItem $runnerFolder -Filter "*.cmd" | Select-Object Name

    Write-Host "`n=== All PowerShell Scripts ===" -ForegroundColor Cyan
    Get-ChildItem $runnerFolder -Filter "*.ps1" | Select-Object Name

    Write-Host "`n=== Check if service already exists ===" -ForegroundColor Cyan
    Get-Service -Name "actions.runner.*" -ErrorAction SilentlyContinue | Select-Object Name, Status, StartType
}
