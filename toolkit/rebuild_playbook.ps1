# Rebuild Playbook Assets and Script Migration

$wallpaperSrc = "C:\Users\ArgusOs\Downloads\a_wallpaper_for_my_optomaze_202606120551.jpeg"
$toolkitScriptSrc = "C:\Users\ArgusOs\.gemini\antigravity\brain\e7412f7b-b490-4907-be8c-e7794b2c2f2c\Argus-Toolkit.ps1"

$playbookDest = "C:\Users\ArgusOs\Downloads\XOS V0.505"
$wallpaperDest1 = Join-Path $playbookDest "playbook.png"
$wallpaperDest2 = Join-Path $playbookDest "Executables\Windows\Web\Wallpaper\ArgusOS\img0.png"
$wallpaperDest3 = Join-Path $playbookDest "Executables\Windows\Web\Wallpaper\ArgusOS\img0.jpeg"
$toolkitDestDir = Join-Path $playbookDest "Executables\ArgusToolkit"
$toolkitScriptDest = Join-Path $toolkitDestDir "Argus-Toolkit.ps1"
$iconDest = Join-Path $toolkitDestDir "icon.ico"
$oldToolkit = Join-Path $playbookDest "Executables\XOS-Toolkit-Setup.exe"

Write-Output "1. Copying wallpaper images..."
if (Test-Path $wallpaperSrc) {
    Copy-Item -Path $wallpaperSrc -Destination $wallpaperDest1 -Force
    # Ensure directory for wallpaper dest 2 exists
    $wall2Dir = Split-Path $wallpaperDest2 -Parent
    if (-not (Test-Path $wall2Dir)) { New-Item -ItemType Directory -Path $wall2Dir -Force | Out-Null }
    Copy-Item -Path $wallpaperSrc -Destination $wallpaperDest2 -Force
    Copy-Item -Path $wallpaperSrc -Destination $wallpaperDest3 -Force
    Write-Output "Wallpaper copied successfully."
} else {
    Write-Error "Wallpaper source not found at $wallpaperSrc"
}

Write-Output "2. Creating Toolkit folder and copying script..."
if (-not (Test-Path $toolkitDestDir)) {
    New-Item -ItemType Directory -Path $toolkitDestDir -Force | Out-Null
}
if (Test-Path $toolkitScriptSrc) {
    Copy-Item -Path $toolkitScriptSrc -Destination $toolkitScriptDest -Force
    Write-Output "Toolkit script copied successfully."
} else {
    Write-Error "Toolkit script source not found at $toolkitScriptSrc"
}

Write-Output "3. Cropping logo from wallpaper center and converting to ICO..."
if (Test-Path $wallpaperSrc) {
    [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") | Out-Null
    $src = [System.Drawing.Image]::FromFile($wallpaperSrc)
    
    # Crop the neon "A" and eye logo in the center
    $cropSize = [int]($src.Height * 0.55)
    $x = [int](($src.Width - $cropSize) / 2)
    # The logo is in the upper-middle (centered around y = 43% of height)
    $y = [int](($src.Height * 0.43) - ($cropSize / 2))
    if ($y -lt 0) { $y = 0 }
    
    $bmp = New-Object System.Drawing.Bitmap 256, 256
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    
    $srcRect = New-Object System.Drawing.Rectangle $x, $y, $cropSize, $cropSize
    $destRect = New-Object System.Drawing.Rectangle 0, 0, 256, 256
    
    $g.DrawImage($src, $destRect, $srcRect, [System.Drawing.GraphicsUnit]::Pixel)
    $g.Dispose()
    $src.Dispose()
    
    # Save as PNG bytes in memory
    $ms = New-Object System.IO.MemoryStream
    $bmp.Save($ms, [System.Drawing.Imaging.ImageFormat]::Png)
    $pngBytes = $ms.ToArray()
    $ms.Dispose()
    $bmp.Dispose()
    
    $pngSize = $pngBytes.Length

    # Construct ICO header (22 bytes)
    $icoHeader = [byte[]]@(
        0, 0,           # Reserved (0)
        1, 0,           # Type (1 = Icon)
        1, 0,           # Image Count (1)
        0,              # Width (0 = 256)
        0,              # Height (0 = 256)
        0,              # Color count (0 = 256+)
        0,              # Reserved (0)
        1, 0,           # Color planes (1)
        32, 0,          # Bits per pixel (32)
        ($pngSize -band 0xFF),
        (($pngSize -shr 8) -band 0xFF),
        (($pngSize -shr 16) -band 0xFF),
        (($pngSize -shr 24) -band 0xFF),
        22, 0, 0, 0
    )

    $icoBytes = New-Object byte[] ($icoHeader.Length + $pngBytes.Length)
    [System.Buffer]::BlockCopy($icoHeader, 0, $icoBytes, 0, $icoHeader.Length)
    [System.Buffer]::BlockCopy($pngBytes, 0, $icoBytes, $icoHeader.Length, $pngBytes.Length)

    [System.IO.File]::WriteAllBytes($iconDest, $icoBytes)
    Write-Output "Icon cropped and saved to $iconDest."
} else {
    Write-Error "Wallpaper source not found at $wallpaperSrc"
}

Write-Output "4. Deleting obsolete XOS toolkit..."
if (Test-Path $oldToolkit) {
    Remove-Item -Path $oldToolkit -Force
    Write-Output "Deleted old toolkit: $oldToolkit."
} else {
    Write-Output "Old toolkit already removed."
}

Write-Output "Rebuild assets and script migration completed successfully."
