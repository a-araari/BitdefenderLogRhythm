##############################################
# Bitdefender GravityZone - Isolate Endpoint
# Description: Isolates a computer from the network
# Author: Auto-generated for LogRhythm Integration
##############################################

param(
    [Parameter(Mandatory=$true)]
    [string]$EndpointName,
    
    [Parameter(Mandatory=$true)]
    [string]$ApiKey,
    
    [Parameter(Mandatory=$true)]
    [string]$CompanyId
)

# Configuration
$apiURL = "https://cloudgz.gravityzone.bitdefender.com/api/v1.0/jsonrpc/network"

# Headers
$headers = @{
    "Authorization" = "Basic $ApiKey"
    "Content-Type"  = "application/json"
}

# Request Body
$body = @{
    "jsonrpc" = "2.0"
    "method"  = "network.isolate"
    "id"      = "isolate-endpoint-$(Get-Date -Format 'yyyyMMddHHmmss')"
    "params"  = @{
        "companyId"    = $CompanyId
        "endpointName" = $EndpointName
    }
} | ConvertTo-Json -Depth 3

# Execute API Call
try {
    Write-Host "🔒 Isolating endpoint: $EndpointName..." -ForegroundColor Yellow
    
    $response = Invoke-RestMethod -Uri $apiURL -Headers $headers -Method Post -Body $body -ErrorAction Stop
    
    if ($response.result) {
        Write-Host "✅ Endpoint isolated successfully in Bitdefender!" -ForegroundColor Green
        Write-Host "Isolated: $EndpointName" -ForegroundColor Gray
        Write-Host "⚠️  This endpoint is now disconnected from the network" -ForegroundColor Yellow
        exit 0
    } else {
        Write-Host "⚠️  Unexpected response format" -ForegroundColor Yellow
        Write-Host "Response: $($response | ConvertTo-Json)" -ForegroundColor Gray
        exit 1
    }
    
} catch {
    Write-Host "❌ ERROR: Failed to isolate endpoint" -ForegroundColor Red
    Write-Host "Error Details: $($_.Exception.Message)" -ForegroundColor Red
    
    if ($_.ErrorDetails.Message) {
        Write-Host "API Error: $($_.ErrorDetails.Message)" -ForegroundColor Red
    }
    
    exit 1
}