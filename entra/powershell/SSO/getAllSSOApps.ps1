## Script to pull all applciations that are congifured for SSO
## to review the configuraitons, status, certificate, client
## credentials, API permissions, etc
##
## This script uses MS Graph APIs using the Invoke-RestMethod command.
## It does not use PowerShell SDK.

## Import dependencies
Import-Module "F:\Users\Sunny\Source\Repos\fhlbc-codewars\fhlbc-codewars\entra\powershell\modules\AccessToken.psm1" -Force

#### Requirements ####
## Get Access Token
# By Prompt
$accesstoken = getAccessTokenByPrompt
# By Azure KV

# By AWS SM

## Get Access Token (end)
## Create headers
$api_headers = @{
    "Content-Type" = "application/json"
    "Authorization" = "Bearer " + $accesstoken.bearer
    "ConsistencyLevel" = "eventual"
}

## Obtain list of Applications in Entra ID
# Create API request
$api_filter = "`$filter=NOT(publisherName eq 'Microsoft Services')&`$count=true&`$top=999" ## Filter excludes first-party apps
$api_uri = "https://graph.microsoft.com/beta/servicePrincipals?$api_filter"

# Call API request
$app_response = Invoke-RestMethod -Uri $api_uri -Method GET -Headers $api_headers

# Conform response
$internalapps = $app_response.value | Select-Object publisherName,id,accountEnabled,createdDateTIme,appDisplayName,appId,appRoleAssignmentRequired,preferredSingleSignOnMode,replyUrls,signInAudience,servicePrincipalType,keyCredentials,passwordCredentials | Where-Object {$_.publisherName -ne "Microsoft Services"}

$internalapps[0]
## Filter for applications that are enabled
## Filter by publisherName ## Any app not using your tenant ID was most likely added using the Admin Consent Flow or is a first-party app
# First-party publisherNames to ignore
$publisherName_exclusions = @( ## This is an array of publisherNames that will be filtered out
    'Active Directory Application Registry',
    'MS Azure Cloud'
)
## Filter by signInAudience
## Filter for applications with SSO configured (SAML/OIDC)
## Export to CSV
# | Export-Csv -NoTypeInformation -Path "F:\Code\exports\exports.csv"