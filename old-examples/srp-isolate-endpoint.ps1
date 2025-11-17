param(
    [Parameter(Mandatory=$true)]
    [string]$endpointName
)

$apiURL = "https://cloudgz.gravityzone.bitdefender.com/api/v1.0/jsonrpc/network"
$companyId = "" # ← À compléter
$headers = @{
    "Authorization" = "Basic VOTRE_CLE_API"
    "Content-Type" = "application/json"
}

$body = @{
    "jsonrpc" = "2.0"
    "method" = "network.isolate"
    "id" = 3
    "params" = @{
        "endpointName" = $endpointName
    }
} | ConvertTo-Json -Depth 3

$response = Invoke-RestMethod -Uri $apiURL -Headers $headers -Method Post -Body $body
Write-Host "✅ Endpoint $endpointName isolé avec succès dans Bitdefender." -ForegroundColor Green
