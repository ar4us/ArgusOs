# Compile PowerShell Script to Executable

$playbookDest = "C:\Users\ArgusOs\Downloads\XOS V0.505"
$scriptPath = Join-Path $playbookDest "Executables\ArgusToolkit\Argus-Toolkit.ps1"
$outputPath = Join-Path $playbookDest "Executables\ArgusToolkit\Argus-Toolkit.exe"
$iconPath = Join-Path $playbookDest "Executables\ArgusToolkit\icon.ico"

Write-Output "1. Checking if ps2exe is installed..."
$hasPs2exe = Get-Command Invoke-ps2exe -ErrorAction SilentlyContinue

if (-not $hasPs2exe) {
    Write-Output "ps2exe module not found. Installing dependencies..."
    # Enable TLS 1.2 for NuGet downloads
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    
    # Install NuGet package provider silently
    Install-PackageProvider -Name NuGet -Force -Scope CurrentUser | Out-Null
    
    # Trust MSGallery
    Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted -ErrorAction SilentlyContinue
    
    # Install ps2exe
    Install-Module -Name ps2exe -Force -SkipPublisherCheck -Scope CurrentUser
    $hasPs2exe = Get-Command Invoke-ps2exe -ErrorAction SilentlyContinue
    if (-not $hasPs2exe) {
        Write-Error "Failed to install ps2exe module. Cannot compile."
        exit 1
    }
    Write-Output "ps2exe installed successfully."
} else {
    Write-Output "ps2exe module is already available."
}

Write-Output "2. Compiling script to standalone .exe..."
if (-not (Test-Path $scriptPath)) {
    Write-Error "Source script not found at $scriptPath"
    exit 1
}

# Run the ps2exe compiler
# -NoConsole: hides the console window behind the WPF GUI
# -RequireAdmin: embeds manifest to request Administrator privileges on run
# -IconFile: embeds the icon.ico into the executable resource
Invoke-ps2exe -InputFile $scriptPath -OutputFile $outputPath -IconFile $iconPath -NoConsole -RequireAdmin

if (Test-Path $outputPath) {
    Write-Output "SUCCESS: Standalone executable compiled successfully!"
    Write-Output "Saved to: $outputPath"
    
    # Optional: Delete the .ps1 script inside the playbook folder to keep it clean and only ship the .exe!
    # Wait, keeping the .ps1 script doesn't hurt, but removing it makes it more professional so users can't modify it easily.
    # Let's delete the .ps1 file inside the playbook dest to reduce clutter.
    Remove-Item $scriptPath -Force -ErrorAction SilentlyContinue
    Write-Output "Deleted temporary PowerShell script file from playbook directory."
} else {
    Write-Error "Compilation failed. Executable was not created."
}
