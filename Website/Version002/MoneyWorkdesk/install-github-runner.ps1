# Install GitHub Actions Runner on VPS
# Organization: zillionresearch
# Repository: BlazorTest001
# Path: C:\Github\actions-runner-blazortest001

$password = ConvertTo-SecureString 'O2mi0r4bR4' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ('administrator', $password)

# Registration token (valid for 1 hour)
$token = "AR2IGFGGRRINTEC2R6XOUIDJEYKB6"

Invoke-Command -ComputerName 107.175.88.36 -Credential $cred -ScriptBlock {
    param($regToken)

    $runnerFolder = "C:\Github\actions-runner-blazortest001"
    $runnerVersion = "2.321.0"

    Write-Host "=== Step 1: Create Runner Directory ===" -ForegroundColor Cyan
    if (-not (Test-Path "C:\Github")) {
        New-Item -Path "C:\Github" -ItemType Directory -Force | Out-Null
        Write-Host "Created C:\Github folder" -ForegroundColor Green
    }

    if (Test-Path $runnerFolder) {
        Write-Host "Runner folder already exists: $runnerFolder" -ForegroundColor Yellow
        Write-Host "Cleaning up existing installation..." -ForegroundColor Yellow
        Remove-Item -Path $runnerFolder -Recurse -Force
    }

    New-Item -Path $runnerFolder -ItemType Directory -Force | Out-Null
    Write-Host "Created runner folder: $runnerFolder" -ForegroundColor Green

    Set-Location $runnerFolder

    Write-Host "`n=== Step 2: Download GitHub Actions Runner ===" -ForegroundColor Cyan
    $downloadUrl = "https://github.com/actions/runner/releases/download/v$runnerVersion/actions-runner-win-x64-$runnerVersion.zip"
    Write-Host "Downloading from: $downloadUrl" -ForegroundColor Gray

    Invoke-WebRequest -Uri $downloadUrl -OutFile "actions-runner.zip"
    Write-Host "Download complete" -ForegroundColor Green

    Write-Host "`n=== Step 3: Extract Runner Files ===" -ForegroundColor Cyan
    Expand-Archive -Path "actions-runner.zip" -DestinationPath . -Force
    Remove-Item "actions-runner.zip"
    Write-Host "Extraction complete" -ForegroundColor Green

    Write-Host "`n=== Step 4: Configure Runner ===" -ForegroundColor Cyan
    Write-Host "Configuring with token..." -ForegroundColor Gray

    # Configure the runner (non-interactive)
    $configArgs = @(
        "--url", "https://github.com/zillionresearch/BlazorTest001",
        "--token", $regToken,
        "--name", "vps-107-175-88-36",
        "--labels", "windows,iis,vps,production",
        "--work", "_work",
        "--unattended"
    )

    & ".\config.cmd" $configArgs

    Write-Host "`n=== Step 5: Install as Windows Service ===" -ForegroundColor Cyan
    & ".\svc.sh" install
    Write-Host "Service installed" -ForegroundColor Green

    Write-Host "`n=== Step 6: Start Service ===" -ForegroundColor Cyan
    & ".\svc.sh" start
    Write-Host "Service started" -ForegroundColor Green

    Start-Sleep -Seconds 3

    Write-Host "`n=== Step 7: Verify Service Status ===" -ForegroundColor Cyan
    & ".\svc.sh" status

    Write-Host "`n=== Installation Complete! ===" -ForegroundColor Green
    Write-Host "Runner installed at: $runnerFolder" -ForegroundColor White
    Write-Host "Service name: actions.runner.zillionresearch-BlazorTest001.vps-107-175-88-36" -ForegroundColor White
    Write-Host "Check GitHub: https://github.com/zillionresearch/BlazorTest001/settings/actions/runners" -ForegroundColor Cyan

} -ArgumentList $token
