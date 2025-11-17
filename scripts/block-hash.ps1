##############################################
# Bitdefender GravityZone - Block Hash
# Description: Blocks a file hash (malware signature)
# Author: Auto-generated for LogRhythm Integration
##############################################

param(
    [Parameter(Mandatory=$true)]
    [string]$Hash,
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("sha256", "md5")]
    [string]$Algorithm = "sha256",
    
    [Parameter(Mandatory=$true)]
    [string]$ApiKey,
    
    [Parameter(Mandatory=$true)]
    [string]$CompanyId
)

# Configuration
$apiURL = "https://cloudgz.gravityzone.bitdefender.com/api/v1.2/jsonrpc/incidents"

# Headers
$headers = @{
    "Authorization" = "Basic $ApiKey"
    "Content-Type"  = "application/json"
}

# Request Body
$body = @{
    "jsonrpc" = "2.0"
    "method"  = "addToBlocklist"
    "id"      = "block-hash-$(Get-Date -Format 'yyyyMMddHHmmss')"
    "params"  = @{
        "companyId" = $CompanyId
        "type"      = "hash"
        "rules"     = @(
            @{
                "details" = @{
                    "algorithm" = $Algorithm
                    "hash"      = $Hash
                }
            }
        )
    }
} | ConvertTo-Json -Depth 5

# Execute API Call
try {
    Write-Host "🔒 Blocking hash: $Hash ($Algorithm)..." -ForegroundColor Yellow
    
    $response = Invoke-RestMethod -Uri $apiURL -Headers $headers -Method Post -Body $body -ErrorAction Stop
    
    if ($response.result) {
        Write-Host "✅ Hash blocked successfully in Bitdefender!" -ForegroundColor Green
        Write-Host "Response: $($response.result | ConvertTo-Json -Compress)" -ForegroundColor Gray
        exit 0
    } else {
        Write-Host "⚠️  Unexpected response format" -ForegroundColor Yellow
        Write-Host "Response: $($response | ConvertTo-Json)" -ForegroundColor Gray
        exit 1
    }
    
} catch {
    Write-Host "❌ ERROR: Failed to block hash" -ForegroundColor Red
    Write-Host "Error Details: $($_.Exception.Message)" -ForegroundColor Red
    
    if ($_.ErrorDetails.Message) {
        Write-Host "API Error: $($_.ErrorDetails.Message)" -ForegroundColor Red
    }
    
    exit 1
}
