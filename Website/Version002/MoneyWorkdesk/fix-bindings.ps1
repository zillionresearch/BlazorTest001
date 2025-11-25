# Fix IIS Bindings - Add missing moneyworkdesk.com binding

$vpsIP = "107.175.88.36"
$vpsUser = "administrator"
$vpsPassword = "O2mi0r4bR4"

# Create credential
$password = ConvertTo-SecureString $vpsPassword -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($vpsUser, $password)

# Execute on VPS
Invoke-Command -ComputerName $vpsIP -Credential $cred -ScriptBlock {
    Import-Module WebAdministration

    $siteName = "BlazorTest001"

    # Check current bindings
    Write-Host "=== Current Bindings ===" -ForegroundColor Cyan
    Get-WebBinding -Name $siteName | Select-Object protocol, bindingInformation | Format-Table -AutoSize

    # Add moneyworkdesk.com if not exists
    $apexBinding = Get-WebBinding -Name $siteName -HostHeader "moneyworkdesk.com"
    if (-not $apexBinding) {
        Write-Host "`nAdding apex domain binding..." -ForegroundColor Yellow
        New-WebBinding -Name $siteName -Protocol "http" -Port 80 -HostHeader "moneyworkdesk.com"
        Write-Host "Added binding: http://moneyworkdesk.com:80" -ForegroundColor Green
    } else {
        Write-Host "`nApex domain binding already exists" -ForegroundColor Green
    }

    # Final verification
    Write-Host "`n=== Final Bindings ===" -ForegroundColor Cyan
    Get-WebBinding -Name $siteName | Select-Object protocol, bindingInformation | Format-Table -AutoSize

    Write-Host "`nSite will respond to:" -ForegroundColor Yellow
    Get-WebBinding -Name $siteName | ForEach-Object {
        Write-Host "  - http://$($_.bindingInformation.Split(':')[2])" -ForegroundColor White
    }
}
