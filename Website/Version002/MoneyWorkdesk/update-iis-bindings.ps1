# Update IIS Site Bindings for Production Domains
# Run this script on VPS via PowerShell Remoting

$siteName = "BlazorTest001"

Import-Module WebAdministration

# Remove existing bindings
Write-Host "Removing old bindings..." -ForegroundColor Yellow
Get-WebBinding -Name $siteName | Remove-WebBinding

# Add new bindings for www.moneyworkdesk.com and moneyworkdesk.com
Write-Host "`nAdding new bindings..." -ForegroundColor Cyan

New-WebBinding -Name $siteName -Protocol "http" -Port 80 -HostHeader "www.moneyworkdesk.com"
Write-Host "✓ Added binding: http://www.moneyworkdesk.com:80" -ForegroundColor Green

New-WebBinding -Name $siteName -Protocol "http" -Port 80 -HostHeader "moneyworkdesk.com"
Write-Host "✓ Added binding: http://moneyworkdesk.com:80" -ForegroundColor Green

# Display current bindings
Write-Host "`n=== Current Site Bindings ===" -ForegroundColor Cyan
Get-WebBinding -Name $siteName | Select-Object protocol, bindingInformation | Format-Table -AutoSize

# Verify app pool is running
$appPoolState = Get-WebAppPoolState -Name $siteName
Write-Host "`nApp Pool Status: $($appPoolState.Value)" -ForegroundColor $(if ($appPoolState.Value -eq "Started") { "Green" } else { "Red" })

Write-Host "`n=== Configuration Complete ===" -ForegroundColor Green
Write-Host "Site will respond to:" -ForegroundColor Yellow
Write-Host "  - http://www.moneyworkdesk.com" -ForegroundColor White
Write-Host "  - http://moneyworkdesk.com" -ForegroundColor White
Write-Host "`nCloudflare will handle HTTPS" -ForegroundColor Gray
