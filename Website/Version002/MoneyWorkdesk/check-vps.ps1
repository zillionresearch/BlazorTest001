# VPS System Check Script

$password = ConvertTo-SecureString 'O2mi0r4bR4' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ('administrator', $password)

Invoke-Command -ComputerName 107.175.88.36 -Credential $cred -ScriptBlock {
    Write-Host "=== System Information ===" -ForegroundColor Cyan
    Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, OsHardwareAbstractionLayer

    Write-Host "`n=== .NET Runtimes Installed ===" -ForegroundColor Cyan
    dotnet --list-runtimes

    Write-Host "`n=== IIS Version ===" -ForegroundColor Cyan
    Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\InetStp\' | Select-Object MajorVersion, MinorVersion

    Write-Host "`n=== Check C:\Websites1 ===" -ForegroundColor Cyan
    if (Test-Path 'C:\Websites1') {
        Write-Host "C:\Websites1 EXISTS" -ForegroundColor Green
        Get-ChildItem 'C:\Websites1' | Select-Object Name, Mode
    } else {
        Write-Host "C:\Websites1 DOES NOT EXIST" -ForegroundColor Yellow
    }

    Write-Host "`n=== Current IIS Sites ===" -ForegroundColor Cyan
    Import-Module WebAdministration
    Get-Website | Select-Object Name, PhysicalPath, State
}
