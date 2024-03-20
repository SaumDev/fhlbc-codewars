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
}

$api_headers.Authorization
## Obtain list of Applications in Entra ID
$api_uri = "https://graph.microsoft.com/beta/applications"
$app_response = Invoke-RestMethod -Uri $api_uri -Method GET -Headers $api_headers
$app_response.value
$app_response.value[0]
## Filter for applications with SSO configured (SAML/OIDC)
## Export to CSV