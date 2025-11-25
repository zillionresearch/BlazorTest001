# GitHub Actions Self-Hosted Runner Installation Checklist

## Purpose
This checklist provides step-by-step instructions for installing GitHub Actions self-hosted runners on Windows VPS servers. Use this for setting up CI/CD deployment pipelines for any GitHub repository.

---

## Prerequisites

### Required Information
- [ ] VPS IP Address
- [ ] VPS Administrator username and password
- [ ] GitHub repository owner/organization name
- [ ] GitHub repository name
- [ ] GitHub authentication (gh CLI logged in)

### Required Software on VPS
- [ ] Windows Server (2019 or later recommended)
- [ ] IIS installed
- [ ] .NET Runtime/Hosting Bundle for your target version
- [ ] PowerShell 5.1 or later

### Required Software on Local Machine
- [ ] PowerShell 5.1 or later
- [ ] GitHub CLI (gh) installed and authenticated
- [ ] WinRM service running

---

## Step 1: Enable PowerShell Remoting

### On VPS (via RDP):

Open PowerShell as Administrator and run:

```powershell
# Enable PowerShell Remoting
Enable-PSRemoting -Force

# Configure firewall
New-NetFirewallRule -Name "WinRM-HTTP" `
    -DisplayName "Windows Remote Management (HTTP-In)" `
    -Enabled True -Direction Inbound `
    -Protocol TCP -LocalPort 5985 `
    -Action Allow

# Configure WinRM
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force
Set-Service WinRM -StartupType Automatic
Restart-Service WinRM

# Test configuration
Test-WSMan
```

### On Local Development Machine:

Open PowerShell as Administrator and run:

```powershell
# Start WinRM service
Start-Service WinRM

# Set to automatic startup
Set-Service WinRM -StartupType Automatic

# Add VPS to TrustedHosts (replace with your VPS IP)
Set-Item WSMan:\localhost\Client\TrustedHosts -Value 'YOUR_VPS_IP' -Force

# Verify
Get-Item WSMan:\localhost\Client\TrustedHosts
```

### Test Connection:

```powershell
Test-WSMan -ComputerName YOUR_VPS_IP
```

---

## Step 2: Get GitHub Runner Registration Token

### For Repository-Level Runner:

```bash
# Replace with your owner/repo
gh api -X POST repos/OWNER/REPO/actions/runners/registration-token --jq .token
```

### For Organization-Level Runner (if you have an org):

```bash
# Replace with your org name
gh api -X POST orgs/ORG_NAME/actions/runners/registration-token --jq .token
```

**Note:** Save this token - it expires in 1 hour and will be used in Step 3.

---

## Step 3: Install Runner on VPS

### Option A: Using PowerShell Remoting (Automated)

Create a PowerShell script (`install-runner.ps1`):

```powershell
# Configuration
$vpsIP = "YOUR_VPS_IP"
$vpsUser = "administrator"
$vpsPassword = "YOUR_PASSWORD"
$repoOwner = "GITHUB_OWNER"
$repoName = "REPO_NAME"
$regToken = "YOUR_REGISTRATION_TOKEN"
$runnerName = "vps-runner-01"
$runnerPath = "C:\Github\actions-runner-$repoName"

# Create credential
$password = ConvertTo-SecureString $vpsPassword -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($vpsUser, $password)

# Install runner
Invoke-Command -ComputerName $vpsIP -Credential $cred -ScriptBlock {
    param($path, $owner, $repo, $token, $name)

    # Create directory
    if (-not (Test-Path "C:\Github")) {
        New-Item -Path "C:\Github" -ItemType Directory -Force | Out-Null
    }

    if (Test-Path $path) {
        Remove-Item -Path $path -Recurse -Force
    }

    New-Item -Path $path -ItemType Directory -Force | Out-Null
    Set-Location $path

    # Download runner (check latest version at https://github.com/actions/runner/releases)
    $runnerVersion = "2.321.0"
    $downloadUrl = "https://github.com/actions/runner/releases/download/v$runnerVersion/actions-runner-win-x64-$runnerVersion.zip"

    Invoke-WebRequest -Uri $downloadUrl -OutFile "actions-runner.zip"
    Expand-Archive -Path "actions-runner.zip" -DestinationPath . -Force
    Remove-Item "actions-runner.zip"

    # Configure runner
    & ".\config.cmd" --url "https://github.com/$owner/$repo" `
        --token $token `
        --name $name `
        --labels "windows,iis,vps,production" `
        --work "_work" `
        --runAsService `
        --windowsLogonAccount "NT AUTHORITY\SYSTEM" `
        --unattended

    Write-Host "`nRunner installed successfully!" -ForegroundColor Green
    Get-Service -Name "actions.runner.*" | Select-Object Name, Status, StartType

} -ArgumentList $runnerPath, $repoOwner, $repoName, $regToken, $runnerName
```

Run the script:

```powershell
.\install-runner.ps1
```

### Option B: Manual Installation (via RDP)

1. RDP to your VPS
2. Open PowerShell as Administrator
3. Run:

```powershell
# Create directory
$runnerPath = "C:\Github\actions-runner-REPONAME"
New-Item -Path $runnerPath -ItemType Directory -Force
Set-Location $runnerPath

# Download runner
$runnerVersion = "2.321.0"
Invoke-WebRequest -Uri "https://github.com/actions/runner/releases/download/v$runnerVersion/actions-runner-win-x64-$runnerVersion.zip" -OutFile "actions-runner.zip"

# Extract
Expand-Archive -Path "actions-runner.zip" -DestinationPath . -Force
Remove-Item "actions-runner.zip"

# Configure (replace with your values)
.\config.cmd --url https://github.com/OWNER/REPO `
    --token YOUR_TOKEN `
    --name vps-runner-01 `
    --labels windows,iis,vps,production `
    --work _work `
    --runAsService `
    --windowsLogonAccount "NT AUTHORITY\SYSTEM" `
    --unattended
```

---

## Step 4: Verify Installation

### Check Service Status on VPS:

```powershell
Get-Service -Name "actions.runner.*" | Select-Object Name, Status, StartType
```

Expected output:
- Status: **Running**
- StartType: **Automatic**

### Check Runner Status on GitHub:

Using GitHub CLI:

```bash
gh api repos/OWNER/REPO/actions/runners --jq '.runners[] | {name, status, busy}'
```

Or visit: `https://github.com/OWNER/REPO/settings/actions/runners`

Expected status: **online** (green dot)

---

## Step 5: Test the Runner

Create a simple workflow file in your repository:

`.github/workflows/test-runner.yml`

```yaml
name: Test Self-Hosted Runner

on:
  workflow_dispatch:

jobs:
  test:
    runs-on: self-hosted

    steps:
    - name: Test runner
      run: |
        Write-Host "Runner is working!"
        Get-ComputerInfo | Select-Object WindowsProductName
```

Trigger manually:

```bash
gh workflow run test-runner.yml
```

Check logs:

```bash
gh run list --workflow=test-runner.yml
```

---

## Troubleshooting

### Runner Shows "Offline"

```powershell
# On VPS, restart the service
Restart-Service -Name "actions.runner.*"

# Check service status
Get-Service -Name "actions.runner.*"

# Check service logs
Get-EventLog -LogName Application -Source "actions.runner.*" -Newest 10
```

### Service Won't Start

```powershell
# Check if runner is configured
Test-Path "C:\Github\actions-runner-REPONAME\.runner"

# If not configured, get new token and reconfigure
cd C:\Github\actions-runner-REPONAME
.\config.cmd remove --token OLD_TOKEN
.\config.cmd --url https://github.com/OWNER/REPO --token NEW_TOKEN --runAsService ...
```

### Need to Reconfigure Runner

```powershell
# Remove existing configuration
cd C:\Github\actions-runner-REPONAME
.\config.cmd remove --token YOUR_TOKEN

# Get new registration token
$newToken = gh api -X POST repos/OWNER/REPO/actions/runners/registration-token --jq .token

# Reconfigure
.\config.cmd --url https://github.com/OWNER/REPO --token $newToken --runAsService ...
```

---

## Managing Multiple Runners on Same VPS

For multiple projects on the same VPS:

1. Create separate folders for each runner:
   - `C:\Github\actions-runner-project1`
   - `C:\Github\actions-runner-project2`
   - `C:\Github\actions-runner-project3`

2. Each gets its own registration token

3. Each installs as a separate Windows service:
   - `actions.runner.owner-project1.runner-name`
   - `actions.runner.owner-project2.runner-name`
   - `actions.runner.owner-project3.runner-name`

4. All run simultaneously and independently

---

## Folder Structure

```
C:\Github\
├── actions-runner-blazortest001\
│   ├── config.cmd
│   ├── run.cmd
│   ├── _work\              (working directory for builds)
│   ├── .credentials
│   └── .runner
├── actions-runner-project2\
└── actions-runner-project3\
```

---

## Service Management Commands

```powershell
# List all runner services
Get-Service -Name "actions.runner.*"

# Start a specific runner
Start-Service -Name "actions.runner.OWNER-REPO.RUNNER-NAME"

# Stop a specific runner
Stop-Service -Name "actions.runner.OWNER-REPO.RUNNER-NAME"

# Restart a specific runner
Restart-Service -Name "actions.runner.OWNER-REPO.RUNNER-NAME"

# Check service details
Get-Service -Name "actions.runner.*" | Format-List *

# View service startup type
Get-WmiObject Win32_Service -Filter "Name LIKE 'actions.runner.%'" | Select-Object Name, StartMode, State
```

---

## Uninstalling a Runner

```powershell
# On VPS
cd C:\Github\actions-runner-REPONAME

# Get a removal token
$removeToken = gh api -X POST repos/OWNER/REPO/actions/runners/remove-token --jq .token

# Remove runner
.\config.cmd remove --token $removeToken

# Delete the folder
cd ..
Remove-Item -Path "C:\Github\actions-runner-REPONAME" -Recurse -Force
```

---

## Security Best Practices

1. ✅ Run runner as `NT AUTHORITY\SYSTEM` (default)
2. ✅ Use repository-specific runners (not organization-wide for sensitive repos)
3. ✅ Regularly update runner version
4. ✅ Monitor runner logs for suspicious activity
5. ✅ Use firewall rules to restrict WinRM access
6. ✅ Disable runners when not in use (for dev/staging environments)

---

## Updating Runner Version

```powershell
# On VPS
cd C:\Github\actions-runner-REPONAME

# Stop service
Stop-Service -Name "actions.runner.*"

# Download new version
$newVersion = "2.XXX.X"
Invoke-WebRequest -Uri "https://github.com/actions/runner/releases/download/v$newVersion/actions-runner-win-x64-$newVersion.zip" -OutFile "update.zip"

# Backup current
Move-Item -Path "bin" -Destination "bin.backup"

# Extract update
Expand-Archive -Path "update.zip" -DestinationPath "." -Force
Remove-Item "update.zip"

# Start service
Start-Service -Name "actions.runner.*"
```

---

## Document History

- **Created:** 2025-11-25
- **Last Updated:** 2025-11-25
- **Tested On:** Windows Server 2022, GitHub Actions Runner v2.321.0
- **Status:** Production Ready ✅
