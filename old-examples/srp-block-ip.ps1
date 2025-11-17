param(
    [Parameter(Mandatory=$true)]
    [string]$ip
)

$apiURL = "https://cloudgz.gravityzone.bitdefender.com/api/v1.2/jsonrpc/incidents"
$companyId = "" # ← À compléter
$headers = @{
    "Authorization" = "Basic VOTRE_CLE_API"
    "Content-Type" = "application/json"
}

$description = "logrhythm-srp-$ip"

$body = @{
    "jsonrpc" = "2.0"
    "method" = "addToBlocklist"
    "id" = "1"
    "params" = @{
        "companyId" = $companyId
        "type" = "connection"
        "rules" = @(
            @{
                "note" = $description
                "details" = @{
                    "ruleName" = "LogRhythm SRP"
                    "protocol" = "any"
                    "direction" = "both"
                    "remoteAddress" = @{
                        "any" = $false
                        "ipMask" = "$ip/32"
                        "portRange" = "1-65535"
                    }
                }
            }
        )
    }
} | ConvertTo-Json -Depth 5

$response = Invoke-RestMethod -Uri $apiURL -Headers $headers -Method Post -Body $body
Write-Host "✅ IP $ip bloquée avec succès dans Bitdefender." -ForegroundColor Green
