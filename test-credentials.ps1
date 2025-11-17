##############################################
# Test Bitdefender API Credentials
# Run this FIRST to verify your credentials work
##############################################

param(
    [Parameter(Mandatory=$true)]
    [string]$ApiKey,
    
    [Parameter(Mandatory=$true)]
    [string]$CompanyId
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Bitdefender API Credential Test" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$apiURL = "https://cloudgz.gravityzone.bitdefender.com/api/v1.0/jsonrpc/network"

# Headers
$headers = @{
    "Authorization" = "Basic $ApiKey"
    "Content-Type"  = "application/json"
}

# Test 1: Get Endpoints List
Write-Host "Test 1: Fetching endpoint list..." -ForegroundColor Yellow

$body = @{
    "jsonrpc" = "2.0"
    "method"  = "getEndpointsList"
    "id"      = 1
    "params"  = @{
        "companyId" = $CompanyId
        "page"      = 1
        "perPage"   = 10
    }
} | ConvertTo-Json -Depth 3

try {
    $response = Invoke-RestMethod -Uri $apiURL -Headers $headers -Method Post -Body $body -ErrorAction Stop
    
    if ($response.result) {
        Write-Host "✅ SUCCESS! API credentials are valid" -ForegroundColor Green
        Write-Host ""
        Write-Host "Found $($response.result.total) total endpoints" -ForegroundColor Gray
        
        if ($response.result.items) {
            Write-Host ""
            Write-Host "Sample endpoints:" -ForegroundColor Cyan
            $response.result.items | Select-Object -First 5 | ForEach-Object {
                Write-Host "  - $($_.name)" -ForegroundColor Gray
            }
        }
        
        Write-Host ""
        Write-Host "✅ You're ready to proceed with the integration!" -ForegroundColor Green
        exit 0
        
    } else {
        Write-Host "⚠️  Unexpected response format" -ForegroundColor Yellow
        Write-Host "Response: $($response | ConvertTo-Json)" -ForegroundColor Gray
        exit 1
    }
    
} catch {
    Write-Host "❌ FAILED! Could not connect to Bitdefender API" -ForegroundColor Red
    Write-Host ""
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    
    if ($_.ErrorDetails.Message) {
        Write-Host "Details: $($_.ErrorDetails.Message)" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "Common issues:" -ForegroundColor Yellow
    Write-Host "  1. API Key is incorrect or expired" -ForegroundColor Gray
    Write-Host "  2. Company ID is incorrect" -ForegroundColor Gray
    Write-Host "  3. API Key doesn't have proper permissions" -ForegroundColor Gray
    Write-Host "  4. Network/firewall blocking the connection" -ForegroundColor Gray
    
    exit 1
}
