# Deploy Windows Virtual Desktop (WVD)

# Install WVD Powershell Module
Install-Module -Name Microsoft.RDInfra.RDPowerShell
Import-Module -Name Microsoft.RDInfra.RDPowerShell
 
# Setting Deployment context
$urlbroker = "https://rdbroker.wvd.microsoft.com"
$aadTenantId = <value from Azure AD Tenant>
$azureSubscriptionId = <value from Azure Subscription>
$myTenantName = "<my-tenant-name>"
Add-RdsAccount -DeploymentUrl $urlbroker

# WVD Tenant Creation
New-RdsTenant -Name $myTenantName -AadTenantId $aadTenantId -AzureSubscriptionId $azureSubscriptionId

# WVD Service Principal Powershell Module
Install-Module AzureAD
Import-Module AzureAD

# Create Service Principal
$aadContext = Connect-AzureAD
$svcPrincipal = New-AzureADApplication -AvailableToOtherTenants $true -DisplayName "Windows Virtual Desktop Svc Principal"
$svcPrincipalCreds = New-AzureADApplicationPasswordCredential -ObjectId $svcPrincipal.ObjectId

# Create a role assignment
Add-RdsAccount -DeploymentUrl "https://rdbroker.wvd.microsoft.com"
New-RdsRoleAssignment -RoleDefinitionName "RDS Owner" -ApplicationId $svcPrincipal.AppId -TenantName $myTenantName

# Sign in with the service principal
$creds = New-Object System.Management.Automation.PSCredential($svcPrincipal.AppId, (ConvertTo-SecureString $svcPrincipalCreds.Value -AsPlainText -Force))
Add-RdsAccount -DeploymentUrl "https://rdbroker.wvd.microsoft.com" -Credential $creds -ServicePrincipal -AadTenantId $aadContext.TenantId.Guid
