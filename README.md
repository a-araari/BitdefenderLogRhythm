# Bitdefender GravityZone - LogRhythm SmartResponse Integration

## Overview

- **Block IP Addresses** - Block malicious IPs across all endpoints
- **Block File Hashes** - Prevent malware execution by hash signature
- **Isolate Endpoints** - Quarantine compromised systems from the network

---

## Package Contents

### PowerShell Scripts
- `block-ip.ps1` - Blocks IP addresses via Bitdefender API
- `block-hash.ps1` - Blocks file hashes (SHA256/MD5)
- `isolate-endpoint.ps1` - Isolates endpoints from network

### XML Configuration Files (for LogRhythm)
- `block-ip.xml` - SmartResponse definition for IP blocking
- `block-hash.xml` - SmartResponse definition for hash blocking
- `isolate-endpoint.xml` - SmartResponse definition for endpoint isolation

---

## Prerequisites

### Required Information from Client:
1. **Bitdefender API Key** (Base64 encoded)
2. **Company ID** (from Bitdefender GravityZone)
3. **LogRhythm version** and access

### System Requirements:
- PowerShell 5.1 or higher
- Network access to Bitdefender GravityZone API
- LogRhythm SmartResponse enabled

---

## How To Run

### Test Scripts Manually (Before LogRhythm Integration)

#### Test Block IP:
```powershell
.\block-ip.ps1 -IpAddress "8.8.8.8" -ApiKey "YOUR_API_KEY_HERE" -CompanyId "YOUR_COMPANY_ID_HERE"
```

#### Test Block Hash:
```powershell
.\block-hash.ps1 -Hash "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855" -Algorithm "sha256" -ApiKey "YOUR_API_KEY_HERE" -CompanyId "YOUR_COMPANY_ID_HERE"
```

#### Test Isolate Endpoint:
```powershell
.\isolate-endpoint.ps1 -EndpointName "TEST-MACHINE" -ApiKey "YOUR_API_KEY_HERE" -CompanyId "YOUR_COMPANY_ID_HERE"
```
---

## ⚖️ License

This integration is provided as-is for use with licensed Bitdefender GravityZone and LogRhythm installations.
