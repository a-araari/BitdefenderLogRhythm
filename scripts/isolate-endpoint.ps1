param(
    [Parameter(Mandatory=$true)]
    [string]$IpAddress,
    
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
$description = "logrhythm-srp-$IpAddress-$timestamp"

# Request Body
$body = @{
    "jsonrpc" = "2.0"
    "method"  = "addToBlocklist"
    "id"      = "block-ip-$(Get-Date -Format 'yyyyMMddHHmmss')"
    "params"  = @{
        "companyId" = $CompanyId
        "type"      = "connection"
        "rules"     = @(
            @{
                "note"    = $Note
                "details" = @{
                    "ruleName"      = "LogRhythm SRP - $IpAddress"
                    "protocol"      = "any"
                    "direction"     = "both"
                    "remoteAddress" = @{
                        "any"       = $false
                        "ipMask"    = "$IpAddress/32"
                        "portRange" = "1-65535"
                    }
                }
            }
        )
    }
} | ConvertTo-Json -Depth 5

# Execute API Call
try {
    Write-Host "🔒 Blocking IP address: $IpAddress..." -ForegroundColor Yellow
    
    $response = Invoke-RestMethod -Uri $apiURL -Headers $headers -Method Post -Body $body -ErrorAction Stop
    
    if ($response.result) {
        Write-Host "IP address blocked successfully in Bitdefender!" -ForegroundColor Green
        Write-Host "Blocked: $IpAddress (both directions, all ports)" -ForegroundColor Gray
        exit 0
    } else {
        Write-Host "Unexpected response format" -ForegroundColor Yellow
        Write-Host "Response: $($response | ConvertTo-Json)" -ForegroundColor Gray
        exit 1
    }
    
} catch {
    Write-Host "ERROR: Failed to block IP address" -ForegroundColor Red
    Write-Host "Error Details: $($_.Exception.Message)" -ForegroundColor Red
    
    if ($_.ErrorDetails.Message) {
        Write-Host "API Error: $($_.ErrorDetails.Message)" -ForegroundColor Red
    }
    
    exit 1
}
