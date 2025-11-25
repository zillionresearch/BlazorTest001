# Configure IIS Site and App Pool for BlazorTest001

$password = ConvertTo-SecureString 'O2mi0r4bR4' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ('administrator', $password)

Invoke-Command -ComputerName 107.175.88.36 -Credential $cred -ScriptBlock {
    Import-Module WebAdministration

    $siteName = "BlazorTest001"
    $appPoolName = "BlazorTest001"
    $physicalPath = "C:\Websites1\BlazorTest001"
    $port = 80  # Standard HTTP port (Cloudflare will handle HTTPS)

    Write-Host "=== Step 1: Create App Pool ===" -ForegroundColor Cyan

    # Check if app pool exists
    if (Test-Path "IIS:\AppPools\$appPoolName") {
        Write-Host "App pool already exists, removing..." -ForegroundColor Yellow
        Remove-WebAppPool -Name $appPoolName
    }

    # Create app pool
    New-WebAppPool -Name $appPoolName
    Write-Host "App pool created: $appPoolName" -ForegroundColor Green

    # Configure app pool
    Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "managedRuntimeVersion" -Value ""
    Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "enable32BitAppOnWin64" -Value $false
    Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "processModel.identityType" -Value "ApplicationPoolIdentity"
    Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "startMode" -Value "AlwaysRunning"
    Write-Host "App pool configured for .NET 10" -ForegroundColor Green

    Write-Host "`n=== Step 2: Create IIS Website ===" -ForegroundColor Cyan

    # Check if site exists
    if (Test-Path "IIS:\Sites\$siteName") {
        Write-Host "Website already exists, removing..." -ForegroundColor Yellow
        Remove-Website -Name $siteName
    }

    # Create website with primary host header (www)
    New-Website -Name $siteName `
        -PhysicalPath $physicalPath `
        -ApplicationPool $appPoolName `
        -Port $port `
        -HostHeader "www.moneyworkdesk.com" `
        -Force

    Write-Host "Website created: $siteName" -ForegroundColor Green

    # Add apex domain binding
    New-WebBinding -Name $siteName -Protocol "http" -Port $port -HostHeader "moneyworkdesk.com"
    Write-Host "Added bindings: http://www.moneyworkdesk.com and http://moneyworkdesk.com" -ForegroundColor Green

    # Configure website
    Set-ItemProperty "IIS:\Sites\$siteName" -Name "preloadEnabled" -Value $true
    Write-Host "Website configured with preload enabled" -ForegroundColor Green

    Write-Host "`n=== Step 3: Start App Pool and Website ===" -ForegroundColor Cyan

    Start-WebAppPool -Name $appPoolName
    Start-Website -Name $siteName
    Start-Sleep -Seconds 3

    Write-Host "`n=== Step 4: Verify Configuration ===" -ForegroundColor Cyan

    # Get app pool status
    $appPool = Get-WebAppPoolState -Name $appPoolName
    Write-Host "App Pool Status: $($appPool.Value)" -ForegroundColor $(if ($appPool.Value -eq 'Started') {'Green'} else {'Red'})

    # Get website status
    $site = Get-Website -Name $siteName
    Write-Host "Website Status: $($site.State)" -ForegroundColor $(if ($site.State -eq 'Started') {'Green'} else {'Red'})
    Write-Host "Website Bindings: http://*:$port" -ForegroundColor White
    Write-Host "Physical Path: $physicalPath" -ForegroundColor White

    Write-Host "`n=== Configuration Complete! ===" -ForegroundColor Green
    Write-Host "Production URLs:" -ForegroundColor Cyan
    Write-Host "  - https://www.moneyworkdesk.com" -ForegroundColor White
    Write-Host "  - https://moneyworkdesk.com" -ForegroundColor White
    Write-Host "Note: Site is empty until first deployment" -ForegroundColor Yellow
    Write-Host "Note: Cloudflare handles HTTPS and DNS" -ForegroundColor Yellow
}
