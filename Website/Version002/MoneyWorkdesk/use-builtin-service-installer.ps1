# Use GitHub Runner's Built-in Service Installer

$password = ConvertTo-SecureString 'O2mi0r4bR4' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ('administrator', $password)

# Need a new registration token
Write-Host "Getting new registration token..." -ForegroundColor Cyan
$token = gh api -X POST repos/zillionresearch/BlazorTest001/actions/runners/registration-token --jq .token

Invoke-Command -ComputerName 107.175.88.36 -Credential $cred -ScriptBlock {
    param($regToken)

    $runnerFolder = "C:\Github\actions-runner-blazortest001"
    Set-Location $runnerFolder

    Write-Host "=== Removing Old Configuration ===" -ForegroundColor Cyan
    & ".\config.cmd" remove --token $regToken

    Write-Host "`n=== Reconfiguring Runner with Service Install ===" -ForegroundColor Cyan
    & ".\config.cmd" --url https://github.com/zillionresearch/BlazorTest001 `
        --token $regToken `
        --name vps-107-175-88-36 `
        --labels windows,iis,vps,production `
        --work _work `
        --runAsService `
        --windowsLogonAccount "NT AUTHORITY\SYSTEM" `
        --unattended

    Write-Host "`n=== Service Should Be Created and Running ===" -ForegroundColor Green
    Start-Sleep -Seconds 5

    Get-Service -Name "actions.runner.*" | Select-Object Name, Status, StartType | Format-Table -AutoSize

} -ArgumentList $token
