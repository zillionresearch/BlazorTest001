# Install GitHub Actions Runner as Windows Service
# This ensures the runner starts automatically on VPS reboot

$password = ConvertTo-SecureString 'O2mi0r4bR4' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ('administrator', $password)

Invoke-Command -ComputerName 107.175.88.36 -Credential $cred -ScriptBlock {
    $runnerFolder = "C:\Github\actions-runner-blazortest001"
    Set-Location $runnerFolder

    Write-Host "=== Step 1: Stop Current Runner Background Job ===" -ForegroundColor Cyan
    Get-Job | Stop-Job
    Get-Job | Remove-Job
    Write-Host "Background jobs stopped" -ForegroundColor Green

    Write-Host "`n=== Step 2: Install Runner as Windows Service ===" -ForegroundColor Cyan

    # Create service using New-Service
    $serviceName = "GitHubActionsRunner-BlazorTest001"
    $displayName = "GitHub Actions Runner - BlazorTest001"
    $description = "GitHub Actions self-hosted runner for zillionresearch/BlazorTest001"
    $binPath = "$runnerFolder\run.cmd"

    # Check if service already exists
    $existingService = Get-Service -Name $serviceName -ErrorAction SilentlyContinue

    if ($existingService) {
        Write-Host "Service already exists. Stopping and removing..." -ForegroundColor Yellow
        Stop-Service -Name $serviceName -Force -ErrorAction SilentlyContinue
        & sc.exe delete $serviceName
        Start-Sleep -Seconds 2
    }

    # Create the service using sc.exe for better control
    Write-Host "Creating Windows Service..." -ForegroundColor Gray
    & sc.exe create $serviceName binPath= "`"$runnerFolder\runsvc.cmd`"" start= auto DisplayName= $displayName
    & sc.exe description $serviceName $description

    Write-Host "`n=== Step 3: Start the Service ===" -ForegroundColor Cyan
    Start-Service -Name $serviceName
    Start-Sleep -Seconds 5

    Write-Host "`n=== Step 4: Verify Service Status ===" -ForegroundColor Cyan
    Get-Service -Name $serviceName | Select-Object Name, Status, StartType | Format-Table -AutoSize

    Write-Host "`n=== Installation Complete! ===" -ForegroundColor Green
    Write-Host "Service Name: $serviceName" -ForegroundColor White
    Write-Host "Status: Running and will auto-start on reboot" -ForegroundColor White
    Write-Host "Check GitHub: https://github.com/zillionresearch/BlazorTest001/settings/actions/runners" -ForegroundColor Cyan
}
