param(
    [Parameter(Mandatory=$true)]
    [string]$hash,

    [Parameter(Mandatory=$true)]
    [ValidateSet("sha256", "md5")]
    [string]$algorithm
)

$apiURL = "https://cloudgz.gravityzone.bitdefender.com/api/v1.2/jsonrpc/incidents"
$companyId = "" # ← À compléter
$headers = @{
    "Authorization" = "Basic VOTRE_CLE_API"
    "Content-Type" = "application/json"
}

$body = @{
    "jsonrpc" = "2.0"
    "method" = "addToBlocklist"
    "id" = "2"
    "params" = @{
        "companyId" = $companyId
        "type" = "hash"
        "rules" = @(
            @{
                "details" = @{
                    "algorithm" = $algorithm
                    "hash" = $hash
                }
            }
        )
    }
} | ConvertTo-Json -Depth 5

$response = Invoke-RestMethod -Uri $apiURL -Headers $headers -Method Post -Body $body
Write-Host "✅ Hash $hash bloqué avec succès dans Bitdefender." -ForegroundColor Green
