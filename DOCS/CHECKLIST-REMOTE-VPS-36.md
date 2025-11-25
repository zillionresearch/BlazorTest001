# VPS Remote Access Checklist - 107.175.88.36

## VPS Information

**IP Address:** 107.175.88.36
**Username:** administrator
**Password:** O2mi0r4bR4
**OS:** Windows Server 2022 Standard
**IIS Version:** 10.0
**.NET Version:** 10.0.0

---

## Remote Access Setup - PowerShell Remoting

### Prerequisites Completed ✅

#### On VPS (107.175.88.36):
- [x] PowerShell Remoting enabled
- [x] WinRM service running and set to automatic
- [x] Firewall rule created (WinRM-HTTP on port 5985)
- [x] TrustedHosts configured to accept connections
- [x] Test-WSMan successful

#### On Local Development Machine:
- [x] WinRM service started and set to automatic
- [x] VPS IP (107.175.88.36) added to TrustedHosts
- [x] PowerShell remoting test successful

---

## Quick Connection Test

### Test Connection from Local Machine:

```powershell
# Test WinRM connectivity
Test-WSMan -ComputerName 107.175.88.36
```

### Connect to VPS via PowerShell Remoting:

```powershell
# Create credential
$password = ConvertTo-SecureString 'O2mi0r4bR4' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ('administrator', $password)

# Connect interactively
Enter-PSSession -ComputerName 107.175.88.36 -Credential $cred

# Or run remote commands
Invoke-Command -ComputerName 107.175.88.36 -Credential $cred -ScriptBlock {
    # Your commands here
    Get-ComputerInfo | Select-Object WindowsProductName
}
```

---

## VPS Current State

### .NET Runtimes Installed:
- Microsoft.AspNetCore.App 8.0.17
- Microsoft.AspNetCore.App 10.0.0 ✅
- Microsoft.NETCore.App 8.0.17
- Microsoft.NETCore.App 10.0.0 ✅

### IIS Configuration:
- **Website Root:** C:\Websites1
- **Active Sites:** 12 running, 1 stopped (Default Web Site)

### Existing Sites in C:\Websites1:
1. www.actionstoday.com
2. www.flipbookly.com
3. www.itrescues.com
4. www.liquidityflex.com
5. www.neurotron.ai
6. www.rave-network.com
7. www.zillioncoin.com
8. www.zilliondesk.com
9. www.zilliongrid.com
10. www.zillionkit.com
11. www.zillionpress.com
12. www.zillionresearchlabs.com
13. www.zilliontrading.com

---

## Deployment Path for BlazorTest001

**Physical Path:** `C:\Websites1\BlazorTest001`
**IIS Site Name:** BlazorTest001 (to be created)
**App Pool Name:** BlazorTest001 (to be created)
**.NET Version:** 10.0

---

## Troubleshooting

### If Connection Fails:

#### On VPS:
```powershell
# Check WinRM service
Get-Service WinRM

# Restart WinRM
Restart-Service WinRM

# Test locally
Test-WSMan

# Check firewall rule
Get-NetFirewallRule -Name "WinRM-HTTP"

# Verify TrustedHosts
Get-Item WSMan:\localhost\Client\TrustedHosts
```

#### On Local Machine:
```powershell
# Check WinRM service
Get-Service WinRM

# Start if stopped
Start-Service WinRM

# Verify TrustedHosts
Get-Item WSMan:\localhost\Client\TrustedHosts

# Should show: 107.175.88.36
```

### Re-enable PowerShell Remoting (if needed):

**On VPS:**
```powershell
Enable-PSRemoting -Force
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force
Restart-Service WinRM
```

**On Local Machine:**
```powershell
Start-Service WinRM
Set-Item WSMan:\localhost\Client\TrustedHosts -Value '107.175.88.36' -Force
```

---

## Security Notes

- PowerShell Remoting uses WinRM over HTTP (port 5985)
- For production, consider using HTTPS (port 5986) with SSL certificates
- TrustedHosts set to "*" on VPS allows any client (acceptable for controlled environment)
- Local machine TrustedHosts limited to specific VPS IP
- Change administrator password after initial setup if needed
- Consider creating dedicated deployment user account

---

## Next Steps

### For GitHub Actions CI/CD:
1. Install GitHub Actions self-hosted runner on VPS
2. Configure runner as Windows service
3. Create deployment workflow in repository
4. Set up IIS site for BlazorTest001
5. Configure automatic deployment on PR merge to master

### Useful Commands:

**Check .NET Version:**
```powershell
Invoke-Command -ComputerName 107.175.88.36 -Credential $cred -ScriptBlock {
    dotnet --version
    dotnet --list-runtimes
}
```

**Check IIS Sites:**
```powershell
Invoke-Command -ComputerName 107.175.88.36 -Credential $cred -ScriptBlock {
    Import-Module WebAdministration
    Get-Website | Select-Object Name, State, PhysicalPath
}
```

**Restart IIS:**
```powershell
Invoke-Command -ComputerName 107.175.88.36 -Credential $cred -ScriptBlock {
    iisreset
}
```

---

## Document History

- **Created:** 2025-11-25
- **Last Updated:** 2025-11-25
- **Status:** Active - PowerShell Remoting Configured ✅
