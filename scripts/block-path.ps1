param(
    [Parameter(Mandatory=$true)]
    [string]$Path,
    
    [Parameter(Mandatory=$true)]
    [string]$ApiKey,
    
    [Parameter(Mandatory=$true)]
    [string]$CompanyId,
    
    [Parameter(Mandatory=$false)]
    [string]$Note = "Blocked by LogRhythm SmartResponse"
)

# Configuration
$apiURL = "https://cloudgz.gravityzone.bitdefender.com/api/v1.2/jsonrpc/incidents"

# Headers
$headers = @{
    "Authorization" = "Basic $ApiKey"
    "Content-Type"  = "application/json"
}

# Generate unique description
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$description = "logrhythm-srp-path-$timestamp"

# Request Body
$body = @{
    "jsonrpc" = "2.0"
    "method"  = "addToBlocklist"
    "id"      = "block-path-$(Get-Date -Format 'yyyyMMddHHmmss')"
    "params"  = @{
        "companyId" = $CompanyId
        "type"      = "path"
        "rules"     = @(
            @{
                "note"    = $Note
                "details" = @{
                    "path" = $Path
                }
            }
        )
    }
} | ConvertTo-Json -Depth 5

# Execute API Call
try {
    Write-Host "Blocking file path: $Path..." -ForegroundColor Yellow
    
    $response = Invoke-RestMethod -Uri $apiURL -Headers $headers -Method Post -Body $body -ErrorAction Stop
    
    if ($response.result) {
        Write-Host "File path blocked successfully in Bitdefender!" -ForegroundColor Green
        Write-Host "Blocked: $Path" -ForegroundColor Gray
        exit 0
    } else {
        Write-Host "Unexpected response format" -ForegroundColor Yellow
        Write-Host "Response: $($response | ConvertTo-Json)" -ForegroundColor Gray
        exit 1
    }
    
} catch {
    Write-Host "ERROR: Failed to block file path" -ForegroundColor Red
    Write-Host "Error Details: $($_.Exception.Message)" -ForegroundColor Red
    
    if ($_.ErrorDetails.Message) {
        Write-Host "API Error: $($_.ErrorDetails.Message)" -ForegroundColor Red
    }
    
    exit 1
}