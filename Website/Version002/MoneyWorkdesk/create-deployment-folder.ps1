# Create Deployment Folder on VPS

$password = ConvertTo-SecureString 'O2mi0r4bR4' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ('administrator', $password)

Invoke-Command -ComputerName 107.175.88.36 -Credential $cred -ScriptBlock {
    $folderPath = "C:\Websites1\BlazorTest001"

    Write-Host "=== Creating BlazorTest001 Folder ===" -ForegroundColor Cyan

    if (Test-Path $folderPath) {
        Write-Host "Folder already exists: $folderPath" -ForegroundColor Yellow
    } else {
        New-Item -Path $folderPath -ItemType Directory -Force | Out-Null
        Write-Host "Folder created: $folderPath" -ForegroundColor Green
    }

    Write-Host "`n=== Setting Permissions ===" -ForegroundColor Cyan

    # Grant IIS_IUSRS full control
    $acl = Get-Acl $folderPath
    $permission = "IIS_IUSRS","FullControl","ContainerInherit,ObjectInherit","None","Allow"
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
    $acl.SetAccessRule($accessRule)
    Set-Acl $folderPath $acl
    Write-Host "IIS_IUSRS permissions set" -ForegroundColor Green

    # Grant IUSR read permissions
    $permission2 = "IUSR","ReadAndExecute","ContainerInherit,ObjectInherit","None","Allow"
    $accessRule2 = New-Object System.Security.AccessControl.FileSystemAccessRule $permission2
    $acl.SetAccessRule($accessRule2)
    Set-Acl $folderPath $acl
    Write-Host "IUSR permissions set" -ForegroundColor Green

    Write-Host "`n=== Verifying Folder ===" -ForegroundColor Cyan
    Get-Item $folderPath | Select-Object FullName, CreationTime, LastWriteTime

    Write-Host "`n=== Current Permissions ===" -ForegroundColor Cyan
    Get-Acl $folderPath | Select-Object -ExpandProperty Access | Select-Object IdentityReference, FileSystemRights, AccessControlType
}
