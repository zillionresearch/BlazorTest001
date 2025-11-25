# Wrapper script to execute IIS binding update on VPS

$vpsIP = "107.175.88.36"
$vpsUser = "administrator"
$vpsPassword = "O2mi0r4bR4"

# Create credential
$password = ConvertTo-SecureString $vpsPassword -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($vpsUser, $password)

# Execute the update script on VPS
Invoke-Command -ComputerName $vpsIP -Credential $cred -FilePath "e:\VSCode\BlazorTest001\Website\Version002\MoneyWorkdesk\update-iis-bindings.ps1"
