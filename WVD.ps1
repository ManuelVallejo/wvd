# Deploy Windows Virtual Desktop (WVD)

# Install Powershell Module
Install-Module -Name Microsoft.RDInfra.RDPowerShell
Import-Module -Name Microsoft.RDInfra.RDPowerShell
 
# Setting Deployment context
$urlbroker = "https://rdbroker.wvd.microsoft.com"
$aadTenantId = <value from Azure AD Tenant>
$azureSubscriptionId = <value from Azure Subscription>
Add-RdsAccount -DeploymentUrl $urlbroker

# WVD Tenant Creation
New-RdsTenant -Name Contoso -AadTenantId $aadTenantId -AzureSubscriptionId $azureSubscriptionId