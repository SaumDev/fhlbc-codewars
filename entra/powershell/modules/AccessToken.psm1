## Prompt for Client Secret
## Pull secret from Azure Key Vault
## Pull secret from AWS SM
## Note: 'at' = access token

## Environmental variables
## Change these to match your environment
$azure_tenant = "saumdev.com" ## Domain used to set up your Azure/Entra ID tenant - often ends with .onmicrosoft.com
$azure_tenantId = "88b6d52e-39b7-45c1-a939-8835c0458ab5"
$client_id = "adde1113-3c48-4a04-928d-262886ca2b50" ## Application ID of the app registration you're using to obtain an Application type access token

## Script variables
## Do not change these
$at_reponse = @{}
$at_reponse["result"] = 0 ## Response to request for access token using this module. 0 is failure, 1 is success. Default is 0.
$at_reponse["bearer"] = ""
$at_reponse["expiration"] = 0


## Prompt Method ##
function getAccessTokenByPrompt(){
    ## Ask user to enter a secret
    $psk = Read-Host "Enter the client secret" #-AsSecureString

    ## Use secret to aquire an access token
    #### Build REST parameters
    $at_uri = "https://login.microsoftonline.com/$azure_tenant/oauth2/v2.0/token"
    $at_body = "grant_type=client_credentials&scope=https://graph.microsoft.com/.default&client_id=$client_id&client_secret=$psk"

    #### Send REST request
    try {
        $temp_response = (Invoke-RestMethod -Uri $at_uri -Method POST -Body $at_body) | Select-Object expires_on,access_token
        $at_reponse["bearer"] = $temp_response.access_token
        $at_reponse["expiration"] = $temp_response.expires_on
        $at_reponse["result"] = 1
        ## Only return the access token and when it expires
    } catch {
        Write-Host "Error attempting to obtain access token"
        Write-Host $_
    }
    Remove-Variable psk ## Remove the client secret that was entered
    return $at_reponse
}

## Azure Key Vault Method ##


## AWS SM Method ##


Export-ModuleMember -Function getAccessTokenByPrompt