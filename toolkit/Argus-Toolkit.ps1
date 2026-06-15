# Add Presentation assemblies
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

# Ensure we run as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "This script must be run as Administrator!"
    exit 1
}

# Helper to format file sizes
function Format-Size($bytes) {
    if ($null -eq $bytes) { return "0 Bytes" }
    if ($bytes -ge 1GB) { return "{0:N2} GB" -f ($bytes / 1GB) }
    if ($bytes -ge 1MB) { return "{0:N2} MB" -f ($bytes / 1MB) }
    if ($bytes -ge 1KB) { return "{0:N2} KB" -f ($bytes / 1KB) }
    return "$bytes Bytes"
}

# XAML UI Definition
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Argus Toolkit" Height="680" Width="980" WindowStartupLocation="CenterScreen"
        WindowStyle="None" AllowsTransparency="True" Background="Transparent">
    <Window.Resources>
        <Style TargetType="TextBlock">
            <Setter Property="FontFamily" Value="Segoe UI, Inter, Arial"/>
            <Setter Property="Foreground" Value="#E4E4E7"/>
        </Style>
        <Style TargetType="CheckBox">
            <Setter Property="Foreground" Value="#E4E4E7"/>
            <Setter Property="Margin" Value="0,4,0,4"/>
            <Setter Property="FontFamily" Value="Segoe UI, Inter"/>
        </Style>
    </Window.Resources>
    
    <Border Background="#0B0C10" CornerRadius="16" BorderBrush="#1F2833" BorderThickness="2">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="60"/> <!-- Title Bar -->
                <RowDefinition Height="*"/>  <!-- Main Content Area -->
            </Grid.RowDefinitions>
            
            <!-- Title Bar Control -->
            <Grid Grid.Row="0" Name="titleBar" Background="#121216" VerticalAlignment="Stretch">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>
                
                <!-- Title Info (Left) -->
                <StackPanel Grid.Column="0" Orientation="Horizontal" VerticalAlignment="Center" Margin="20,0,0,0">
                    <TextBlock Text="ARGUS TOOLKIT" FontSize="20" FontWeight="Bold" Foreground="#66FCF1" VerticalAlignment="Center"/>
                    <TextBlock Text="|" FontSize="20" Foreground="#45A29E" Margin="10,0" VerticalAlignment="Center"/>
                    <TextBlock Text="Optimized for Gaming" FontSize="12" Foreground="#C5C6C7" VerticalAlignment="Center"/>
                    <TextBlock Text="|" FontSize="20" Foreground="#45A29E" Margin="10,0" VerticalAlignment="Center"/>
                    <TextBlock Text="v1.1.0" FontSize="12" Foreground="#45A29E" VerticalAlignment="Center"/>
                </StackPanel>
                
                <!-- Min / Close Buttons (Right) -->
                <StackPanel Grid.Column="1" Orientation="Horizontal" VerticalAlignment="Center" Margin="0,0,15,0">
                    <Button Name="btnMin" Content="-" Width="30" Height="25" Background="Transparent" Foreground="#C5C6C7" BorderThickness="0" FontSize="18" Cursor="Hand" VerticalContentAlignment="Center"/>
                    <Button Name="btnClose" Content="×" Width="30" Height="25" Background="Transparent" Foreground="#C5C6C7" BorderThickness="0" FontSize="18" Cursor="Hand" VerticalContentAlignment="Center" Margin="5,0,0,0"/>
                </StackPanel>
            </Grid>
            
            <!-- Main Content: App Installer -->
            <Grid Grid.Row="1" Name="panelInstaller" Margin="20" Visibility="Visible">
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="*"/>
                    <RowDefinition Height="80"/>
                </Grid.RowDefinitions>
                
                <TextBlock Grid.Row="0" Text="Select Apps to Install Silently (Utilizing WinGet &amp; Chocolatey)" FontSize="18" FontWeight="SemiBold" Margin="0,0,0,15"/>
                
                <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto">
                    <Grid>
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        
                        <!-- Col 1: Web, Games & Compression -->
                        <StackPanel Grid.Column="0" Margin="5">
                            <Border Background="#121216" Padding="10" CornerRadius="8" Margin="0,0,0,10" BorderBrush="#1F2833" BorderThickness="1">
                                <StackPanel>
                                    <TextBlock Text="Web Browsers" FontSize="13" FontWeight="Bold" Foreground="#66FCF1" Margin="0,0,0,8"/>
                                    <CheckBox Name="chkChrome" Content="Google Chrome"/>
                                    <CheckBox Name="chkBrave" Content="Brave Browser"/>
                                    <CheckBox Name="chkFirefox" Content="Mozilla Firefox"/>
                                    <CheckBox Name="chkOpera" Content="Opera Browser"/>
                                    <CheckBox Name="chkOperaGX" Content="Opera GX"/>
                                    <CheckBox Name="chkEdge" Content="Microsoft Edge"/>
                                    <CheckBox Name="chkLibreWolf" Content="LibreWolf"/>
                                    <CheckBox Name="chkVivaldi" Content="Vivaldi"/>
                                    <CheckBox Name="chkTor" Content="Tor Browser"/>
                                    <CheckBox Name="chkWaterfox" Content="Waterfox"/>
                                </StackPanel>
                            </Border>
                            <Border Background="#121216" Padding="10" CornerRadius="8" Margin="0,0,0,10" BorderBrush="#1F2833" BorderThickness="1">
                                <StackPanel>
                                    <TextBlock Text="Game Launchers &amp; Tools" FontSize="13" FontWeight="Bold" Foreground="#66FCF1" Margin="0,0,0,8"/>
                                    <CheckBox Name="chkSteam" Content="Steam"/>
                                    <CheckBox Name="chkEpic" Content="Epic Games Launcher"/>
                                    <CheckBox Name="chkUbisoft" Content="Ubisoft Connect"/>
                                    <CheckBox Name="chkEA" Content="EA Desktop App"/>
                                    <CheckBox Name="chkGOG" Content="GOG Galaxy"/>
                                    <CheckBox Name="chkGeForceNow" Content="GeForce NOW"/>
                                    <CheckBox Name="chkItch" Content="Itch.io"/>
                                    <CheckBox Name="chkPrism" Content="Prism Launcher"/>
                                    <CheckBox Name="chkModrinth" Content="Modrinth App"/>
                                </StackPanel>
                            </Border>
                            <Border Background="#121216" Padding="10" CornerRadius="8" BorderBrush="#1F2833" BorderThickness="1">
                                <StackPanel>
                                    <TextBlock Text="Compression" FontSize="13" FontWeight="Bold" Foreground="#66FCF1" Margin="0,0,0,8"/>
                                    <CheckBox Name="chk7Zip" Content="7-Zip"/>
                                    <CheckBox Name="chkWinRAR" Content="WinRAR"/>
                                    <CheckBox Name="chkPeaZip" Content="PeaZip"/>
                                </StackPanel>
                            </Border>
                        </StackPanel>
                        
                        <!-- Col 2: Messaging, Media & Utilities -->
                        <StackPanel Grid.Column="1" Margin="5">
                            <Border Background="#121216" Padding="10" CornerRadius="8" Margin="0,0,0,10" BorderBrush="#1F2833" BorderThickness="1">
                                <StackPanel>
                                    <TextBlock Text="Messaging &amp; Comm" FontSize="13" FontWeight="Bold" Foreground="#66FCF1" Margin="0,0,0,8"/>
                                    <CheckBox Name="chkDiscord" Content="Discord"/>
                                    <CheckBox Name="chkTelegram" Content="Telegram Desktop"/>
                                    <CheckBox Name="chkZoom" Content="Zoom Meetings"/>
                                    <CheckBox Name="chkTeams" Content="Microsoft Teams"/>
                                    <CheckBox Name="chkSignal" Content="Signal Messenger"/>
                                    <CheckBox Name="chkSlack" Content="Slack"/>
                                    <CheckBox Name="chkViber" Content="Viber"/>
                                    <CheckBox Name="chkElement" Content="Element"/>
                                    <CheckBox Name="chkSkype" Content="Skype"/>
                                </StackPanel>
                            </Border>
                            <Border Background="#121216" Padding="10" CornerRadius="8" Margin="0,0,0,10" BorderBrush="#1F2833" BorderThickness="1">
                                <StackPanel>
                                    <TextBlock Text="Media &amp; Creation" FontSize="13" FontWeight="Bold" Foreground="#66FCF1" Margin="0,0,0,8"/>
                                    <CheckBox Name="chkVLC" Content="VLC Media Player"/>
                                    <CheckBox Name="chkSpotify" Content="Spotify"/>
                                    <CheckBox Name="chkiTunes" Content="iTunes"/>
                                    <CheckBox Name="chkAIMP" Content="AIMP Player"/>
                                    <CheckBox Name="chkOBS" Content="OBS Studio"/>
                                    <CheckBox Name="chkGIMP" Content="GIMP"/>
                                    <CheckBox Name="chkPaintNet" Content="Paint.NET"/>
                                    <CheckBox Name="chkAudacity" Content="Audacity"/>
                                    <CheckBox Name="chkBlender" Content="Blender (3D Graphics)"/>
                                    <CheckBox Name="chkHandBrake" Content="HandBrake (Converter)"/>
                                    <CheckBox Name="chkImageGlass" Content="ImageGlass (Viewer)"/>
                                    <CheckBox Name="chkCalibre" Content="Calibre (E-books)"/>
                                </StackPanel>
                            </Border>
                            <Border Background="#121216" Padding="10" CornerRadius="8" BorderBrush="#1F2833" BorderThickness="1">
                                <StackPanel>
                                    <TextBlock Text="Utilities" FontSize="13" FontWeight="Bold" Foreground="#66FCF1" Margin="0,0,0,8"/>
                                    <CheckBox Name="chkRevo" Content="Revo Uninstaller"/>
                                    <CheckBox Name="chkWizTree" Content="WizTree Disk Analyzer"/>
                                    <CheckBox Name="chkAnyDesk" Content="AnyDesk"/>
                                    <CheckBox Name="chkqBittorrent" Content="qBittorrent"/>
                                    <CheckBox Name="chkRustDesk" Content="RustDesk"/>
                                    <CheckBox Name="chkRufus" Content="Rufus (USB Tool)"/>
                                    <CheckBox Name="chkVentoy" Content="Ventoy (Multiboot)"/>
                                    <CheckBox Name="chkBleachBit" Content="BleachBit (Clean Utility)"/>
                                </StackPanel>
                            </Border>
                        </StackPanel>
                        
                        <!-- Col 3: Runtimes, Dev Tools & Pro Hardware -->
                        <StackPanel Grid.Column="2" Margin="5">
                            <Border Background="#121216" Padding="10" CornerRadius="8" Margin="0,0,0,10" BorderBrush="#1F2833" BorderThickness="1">
                                <StackPanel>
                                    <TextBlock Text="Runtimes &amp; Frameworks" FontSize="13" FontWeight="Bold" Foreground="#66FCF1" Margin="0,0,0,8"/>
                                    <CheckBox Name="chkVC" Content="VC++ Runtimes AIO (Choco)" IsChecked="True"/>
                                    <CheckBox Name="chkNet35" Content=".NET Framework 3.5 (AIO)" IsChecked="True"/>
                                    <CheckBox Name="chkNet48" Content=".NET Framework 4.8 (Choco)"/>
                                    <CheckBox Name="chkNet8" Content=".NET Desktop Runtime 8"/>
                                    <CheckBox Name="chkNet9" Content=".NET Desktop Runtime 9"/>
                                    <CheckBox Name="chkNet10" Content=".NET Desktop Runtime 10"/>
                                    <CheckBox Name="chkDirectX" Content="DirectX Runtime (Choco)" IsChecked="True"/>
                                    <CheckBox Name="chkJava" Content="Java JRE/JDK (Adoptium)"/>
                                </StackPanel>
                            </Border>
                            <Border Background="#121216" Padding="10" CornerRadius="8" Margin="0,0,0,10" BorderBrush="#1F2833" BorderThickness="1">
                                <StackPanel>
                                    <TextBlock Text="Developer Tools" FontSize="13" FontWeight="Bold" Foreground="#66FCF1" Margin="0,0,0,8"/>
                                    <CheckBox Name="chkVSCode" Content="VS Code"/>
                                    <CheckBox Name="chkNotepad" Content="Notepad++"/>
                                    <CheckBox Name="chkPython" Content="Python 3"/>
                                    <CheckBox Name="chkGit" Content="Git"/>
                                    <CheckBox Name="chkFileZilla" Content="FileZilla Client"/>
                                    <CheckBox Name="chkGitHub" Content="GitHub Desktop"/>
                                    <CheckBox Name="chkNodeJS" Content="NodeJS (LTS)"/>
                                    <CheckBox Name="chkIntelliJ" Content="IntelliJ IDEA Community"/>
                                    <CheckBox Name="chkPyCharm" Content="PyCharm Community"/>
                                    <CheckBox Name="chkGo" Content="Go"/>
                                    <CheckBox Name="chkRust" Content="RustUp"/>
                                    <CheckBox Name="chkNeovim" Content="Neovim"/>
                                </StackPanel>
                            </Border>
                            <Border Background="#121216" Padding="10" CornerRadius="8" BorderBrush="#1F2833" BorderThickness="1">
                                <StackPanel>
                                    <TextBlock Text="Hardware &amp; Pro Tools" FontSize="13" FontWeight="Bold" Foreground="#66FCF1" Margin="0,0,0,8"/>
                                    <CheckBox Name="chkCPUZ" Content="CPU-Z"/>
                                    <CheckBox Name="chkGPUZ" Content="GPU-Z"/>
                                    <CheckBox Name="chkHWMonitor" Content="HWMonitor"/>
                                    <CheckBox Name="chkDDU" Content="Display Driver Uninstaller"/>
                                    <CheckBox Name="chkPowerToys" Content="Microsoft PowerToys"/>
                                    <CheckBox Name="chkTerminal" Content="Windows Terminal"/>
                                    <CheckBox Name="chkWireshark" Content="Wireshark"/>
                                    <CheckBox Name="chkHWiNFO" Content="HWiNFO64"/>
                                    <CheckBox Name="chkProcExp" Content="Process Explorer"/>
                                    <CheckBox Name="chkSysSuite" Content="Sysinternals Suite"/>
                                    <CheckBox Name="chkIpScanner" Content="Advanced IP Scanner"/>
                                </StackPanel>
                            </Border>
                        </StackPanel>
                    </Grid>
                </ScrollViewer>
                
                <!-- Bottom Controls -->
                <Grid Grid.Row="2" Margin="0,10,0,0">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="200"/>
                    </Grid.ColumnDefinitions>
                    
                    <StackPanel Grid.Column="0" VerticalAlignment="Center">
                        <TextBlock Name="lblInstallStatus" Text="Ready to install" FontSize="12" Foreground="#C5C6C7" FontWeight="SemiBold" TextTrimming="CharacterEllipsis"/>
                        <ProgressBar Name="pbProgress" Height="8" Background="#1F2833" Foreground="#66FCF1" BorderThickness="0" Margin="0,8,0,0" Minimum="0" Maximum="100" Value="0"/>
                    </StackPanel>
                    
                    <Button Grid.Column="1" Name="btnInstall" Content="Install Selected" Height="45" Width="180" Background="#66FCF1" Foreground="#0B0C10" BorderThickness="0" HorizontalAlignment="Right" VerticalAlignment="Center" Cursor="Hand" FontWeight="Bold">
                        <Button.Resources>
                            <Style TargetType="Border">
                                <Setter Property="CornerRadius" Value="8"/>
                            </Style>
                        </Button.Resources>
                    </Button>
                </Grid>
            </Grid>
        </Grid>
    </Border>
</Window>
"@

# Load XML into Reader
$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

# Get Window elements
$titleBar = $window.FindName("titleBar")
$btnMin = $window.FindName("btnMin")
$btnClose = $window.FindName("btnClose")

$btnInstall = $window.FindName("btnInstall")
$lblInstallStatus = $window.FindName("lblInstallStatus")
$pbProgress = $window.FindName("pbProgress")

# Web Browsers
$chkChrome = $window.FindName("chkChrome")
$chkBrave = $window.FindName("chkBrave")
$chkFirefox = $window.FindName("chkFirefox")
$chkOpera = $window.FindName("chkOpera")
$chkOperaGX = $window.FindName("chkOperaGX")
$chkEdge = $window.FindName("chkEdge")
$chkLibreWolf = $window.FindName("chkLibreWolf")
$chkVivaldi = $window.FindName("chkVivaldi")
$chkTor = $window.FindName("chkTor")
$chkWaterfox = $window.FindName("chkWaterfox")

# Game Launchers
$chkSteam = $window.FindName("chkSteam")
$chkEpic = $window.FindName("chkEpic")
$chkUbisoft = $window.FindName("chkUbisoft")
$chkEA = $window.FindName("chkEA")
$chkGOG = $window.FindName("chkGOG")
$chkGeForceNow = $window.FindName("chkGeForceNow")
$chkItch = $window.FindName("chkItch")
$chkPrism = $window.FindName("chkPrism")
$chkModrinth = $window.FindName("chkModrinth")

# Compression
$chk7Zip = $window.FindName("chk7Zip")
$chkWinRAR = $window.FindName("chkWinRAR")
$chkPeaZip = $window.FindName("chkPeaZip")

# Messaging
$chkDiscord = $window.FindName("chkDiscord")
$chkTelegram = $window.FindName("chkTelegram")
$chkZoom = $window.FindName("chkZoom")
$chkTeams = $window.FindName("chkTeams")
$chkSignal = $window.FindName("chkSignal")
$chkSlack = $window.FindName("chkSlack")
$chkViber = $window.FindName("chkViber")
$chkElement = $window.FindName("chkElement")
$chkSkype = $window.FindName("chkSkype")

# Media & Creation
$chkVLC = $window.FindName("chkVLC")
$chkSpotify = $window.FindName("chkSpotify")
$chkiTunes = $window.FindName("chkiTunes")
$chkAIMP = $window.FindName("chkAIMP")
$chkOBS = $window.FindName("chkOBS")
$chkGIMP = $window.FindName("chkGIMP")
$chkPaintNet = $window.FindName("chkPaintNet")
$chkAudacity = $window.FindName("chkAudacity")
$chkBlender = $window.FindName("chkBlender")
$chkHandBrake = $window.FindName("chkHandBrake")
$chkImageGlass = $window.FindName("chkImageGlass")
$chkCalibre = $window.FindName("chkCalibre")

# Utilities
$chkRevo = $window.FindName("chkRevo")
$chkWizTree = $window.FindName("chkWizTree")
$chkAnyDesk = $window.FindName("chkAnyDesk")
$chkqBittorrent = $window.FindName("chkqBittorrent")
$chkRustDesk = $window.FindName("chkRustDesk")
$chkRufus = $window.FindName("chkRufus")
$chkVentoy = $window.FindName("chkVentoy")
$chkBleachBit = $window.FindName("chkBleachBit")

# Runtimes & Frameworks
$chkVC = $window.FindName("chkVC")
$chkNet35 = $window.FindName("chkNet35")
$chkNet48 = $window.FindName("chkNet48")
$chkNet8 = $window.FindName("chkNet8")
$chkNet9 = $window.FindName("chkNet9")
$chkNet10 = $window.FindName("chkNet10")
$chkDirectX = $window.FindName("chkDirectX")
$chkJava = $window.FindName("chkJava")

# Developer Tools
$chkVSCode = $window.FindName("chkVSCode")
$chkNotepad = $window.FindName("chkNotepad")
$chkPython = $window.FindName("chkPython")
$chkGit = $window.FindName("chkGit")
$chkFileZilla = $window.FindName("chkFileZilla")
$chkGitHub = $window.FindName("chkGitHub")
$chkNodeJS = $window.FindName("chkNodeJS")
$chkIntelliJ = $window.FindName("chkIntelliJ")
$chkPyCharm = $window.FindName("chkPyCharm")
$chkGo = $window.FindName("chkGo")
$chkRust = $window.FindName("chkRust")
$chkNeovim = $window.FindName("chkNeovim")

# Hardware & Pro Tools
$chkCPUZ = $window.FindName("chkCPUZ")
$chkGPUZ = $window.FindName("chkGPUZ")
$chkHWMonitor = $window.FindName("chkHWMonitor")
$chkDDU = $window.FindName("chkDDU")
$chkPowerToys = $window.FindName("chkPowerToys")
$chkTerminal = $window.FindName("chkTerminal")
$chkWireshark = $window.FindName("chkWireshark")
$chkHWiNFO = $window.FindName("chkHWiNFO")
$chkProcExp = $window.FindName("chkProcExp")
$chkSysSuite = $window.FindName("chkSysSuite")
$chkIpScanner = $window.FindName("chkIpScanner")

# Draggable Window Logic
$titleBar.Add_MouseDown({
    if ($_.ChangedButton -eq 'Left') {
        $window.DragMove()
    }
})

# Close and Minimize logic
$btnClose.Add_Click({ $window.Close() })
$btnMin.Add_Click({ $window.WindowState = 'Minimized' })

# ----------------- APP INSTALLER LOGIC -----------------
$btnInstall.Add_Click({
    $btnInstall.IsEnabled = $false
    
    # List of apps to process
    $selectedApps = @()
    
    # Web Browsers
    if ($chkChrome.IsChecked) { $selectedApps += @{ Name = "Google Chrome"; ID = "Google.Chrome"; Manager = "winget" } }
    if ($chkBrave.IsChecked) { $selectedApps += @{ Name = "Brave Browser"; ID = "Brave.Brave"; Manager = "winget" } }
    if ($chkFirefox.IsChecked) { $selectedApps += @{ Name = "Mozilla Firefox"; ID = "Mozilla.Firefox"; Manager = "winget" } }
    if ($chkOpera.IsChecked) { $selectedApps += @{ Name = "Opera Browser"; ID = "Opera.Opera"; Manager = "winget" } }
    if ($chkOperaGX.IsChecked) { $selectedApps += @{ Name = "Opera GX"; ID = "Opera.OperaGX"; Manager = "winget" } }
    if ($chkEdge.IsChecked) { $selectedApps += @{ Name = "Microsoft Edge"; ID = "Microsoft.Edge"; Manager = "winget" } }
    if ($chkLibreWolf.IsChecked) { $selectedApps += @{ Name = "LibreWolf"; ID = "LibreWolf.LibreWolf"; Manager = "winget" } }
    if ($chkVivaldi.IsChecked) { $selectedApps += @{ Name = "Vivaldi"; ID = "VivaldiTechnologies.Vivaldi"; Manager = "winget" } }
    if ($chkTor.IsChecked) { $selectedApps += @{ Name = "Tor Browser"; ID = "TorProject.TorBrowser"; Manager = "winget" } }
    if ($chkWaterfox.IsChecked) { $selectedApps += @{ Name = "Waterfox"; ID = "Waterfox.Waterfox"; Manager = "winget" } }
    
    # Game Launchers
    if ($chkSteam.IsChecked) { $selectedApps += @{ Name = "Steam"; ID = "Valve.Steam"; Manager = "winget" } }
    if ($chkEpic.IsChecked) { $selectedApps += @{ Name = "Epic Games Launcher"; ID = "EpicGames.EpicGamesLauncher"; Manager = "winget" } }
    if ($chkUbisoft.IsChecked) { $selectedApps += @{ Name = "Ubisoft Connect"; ID = "Ubisoft.UbisoftConnect"; Manager = "winget" } }
    if ($chkEA.IsChecked) { $selectedApps += @{ Name = "EA Desktop App"; ID = "ElectronicArts.EADesktop"; Manager = "winget" } }
    if ($chkGOG.IsChecked) { $selectedApps += @{ Name = "GOG Galaxy"; ID = "GOG.Galaxy"; Manager = "winget" } }
    if ($chkGeForceNow.IsChecked) { $selectedApps += @{ Name = "GeForce NOW"; ID = "NVIDIA.GeForceNOW"; Manager = "winget" } }
    if ($chkItch.IsChecked) { $selectedApps += @{ Name = "Itch.io"; ID = "ItchAssociation.Itch"; Manager = "winget" } }
    if ($chkPrism.IsChecked) { $selectedApps += @{ Name = "Prism Launcher"; ID = "PrismLauncher.PrismLauncher"; Manager = "winget" } }
    if ($chkModrinth.IsChecked) { $selectedApps += @{ Name = "Modrinth App"; ID = "Modrinth.ModrinthApp"; Manager = "winget" } }
    
    # Compression
    if ($chk7Zip.IsChecked) { $selectedApps += @{ Name = "7-Zip"; ID = "7zip.7zip"; Manager = "winget" } }
    if ($chkWinRAR.IsChecked) { $selectedApps += @{ Name = "WinRAR"; ID = "RARLab.WinRAR"; Manager = "winget" } }
    if ($chkPeaZip.IsChecked) { $selectedApps += @{ Name = "PeaZip"; ID = "GiorgioTani.PeaZip"; Manager = "winget" } }
    
    # Messaging
    if ($chkDiscord.IsChecked) { $selectedApps += @{ Name = "Discord"; ID = "Discord.Discord"; Manager = "winget" } }
    if ($chkTelegram.IsChecked) { $selectedApps += @{ Name = "Telegram Desktop"; ID = "Telegram.TelegramDesktop"; Manager = "winget" } }
    if ($chkZoom.IsChecked) { $selectedApps += @{ Name = "Zoom Meetings"; ID = "Zoom.Zoom"; Manager = "winget" } }
    if ($chkTeams.IsChecked) { $selectedApps += @{ Name = "Microsoft Teams"; ID = "Microsoft.Teams"; Manager = "winget" } }
    if ($chkSignal.IsChecked) { $selectedApps += @{ Name = "Signal Messenger"; ID = "OpenWhisperSystems.Signal"; Manager = "winget" } }
    if ($chkSlack.IsChecked) { $selectedApps += @{ Name = "Slack"; ID = "Slack.Slack"; Manager = "winget" } }
    if ($chkViber.IsChecked) { $selectedApps += @{ Name = "Viber"; ID = "Viber.Viber"; Manager = "winget" } }
    if ($chkElement.IsChecked) { $selectedApps += @{ Name = "Element"; ID = "Element.Element"; Manager = "winget" } }
    if ($chkSkype.IsChecked) { $selectedApps += @{ Name = "Skype"; ID = "Microsoft.Skype"; Manager = "winget" } }
    
    # Media & Creation
    if ($chkVLC.IsChecked) { $selectedApps += @{ Name = "VLC Media Player"; ID = "VideoLAN.VLC"; Manager = "winget" } }
    if ($chkSpotify.IsChecked) { $selectedApps += @{ Name = "Spotify"; ID = "Spotify.Spotify"; Manager = "winget" } }
    if ($chkiTunes.IsChecked) { $selectedApps += @{ Name = "iTunes"; ID = "Apple.iTunes"; Manager = "winget" } }
    if ($chkAIMP.IsChecked) { $selectedApps += @{ Name = "AIMP Player"; ID = "AIMP.AIMP"; Manager = "winget" } }
    if ($chkOBS.IsChecked) { $selectedApps += @{ Name = "OBS Studio"; ID = "Obsproject.OBSStudio"; Manager = "winget" } }
    if ($chkGIMP.IsChecked) { $selectedApps += @{ Name = "GIMP"; ID = "GIMP.GIMP"; Manager = "winget" } }
    if ($chkPaintNet.IsChecked) { $selectedApps += @{ Name = "Paint.NET"; ID = "dotPDN.PaintDotNet"; Manager = "winget" } }
    if ($chkAudacity.IsChecked) { $selectedApps += @{ Name = "Audacity"; ID = "Audacity.Audacity"; Manager = "winget" } }
    if ($chkBlender.IsChecked) { $selectedApps += @{ Name = "Blender"; ID = "BlenderFoundation.Blender"; Manager = "winget" } }
    if ($chkHandBrake.IsChecked) { $selectedApps += @{ Name = "HandBrake"; ID = "HandBrake.HandBrake"; Manager = "winget" } }
    if ($chkImageGlass.IsChecked) { $selectedApps += @{ Name = "ImageGlass"; ID = "ImageGlass.ImageGlass"; Manager = "winget" } }
    if ($chkCalibre.IsChecked) { $selectedApps += @{ Name = "Calibre"; ID = "KovidGoyal.Calibre"; Manager = "winget" } }
    
    # Utilities
    if ($chkRevo.IsChecked) { $selectedApps += @{ Name = "Revo Uninstaller"; ID = "RevoUninstaller.RevoUninstaller"; Manager = "winget" } }
    if ($chkWizTree.IsChecked) { $selectedApps += @{ Name = "WizTree"; ID = "Polybius.WizTree"; Manager = "winget" } }
    if ($chkAnyDesk.IsChecked) { $selectedApps += @{ Name = "AnyDesk"; ID = "AnyDeskSoftware.AnyDesk"; Manager = "winget" } }
    if ($chkqBittorrent.IsChecked) { $selectedApps += @{ Name = "qBittorrent"; ID = "qBittorrent.qBittorrent"; Manager = "winget" } }
    if ($chkRustDesk.IsChecked) { $selectedApps += @{ Name = "RustDesk"; ID = "RustDesk.RustDesk"; Manager = "winget" } }
    if ($chkRufus.IsChecked) { $selectedApps += @{ Name = "Rufus"; ID = "Akeo.Rufus"; Manager = "winget" } }
    if ($chkVentoy.IsChecked) { $selectedApps += @{ Name = "Ventoy"; ID = "Ventoy.Ventoy"; Manager = "winget" } }
    if ($chkBleachBit.IsChecked) { $selectedApps += @{ Name = "BleachBit"; ID = "BleachBit.BleachBit"; Manager = "winget" } }
    
    # Runtimes & Frameworks (Utilizing Chocolatey where appropriate)
    if ($chkVC.IsChecked) { $selectedApps += @{ Name = "VC++ Runtimes (AIO)"; ID = "vcredist-all"; Manager = "choco" } }
    if ($chkNet35.IsChecked) { $selectedApps += @{ Name = ".NET Framework 3.5 (AIO)"; ID = "dotnet3.5"; Manager = "choco" } }
    if ($chkNet48.IsChecked) { $selectedApps += @{ Name = ".NET Framework 4.8"; ID = "dotnet4.8"; Manager = "choco" } }
    if ($chkNet8.IsChecked) { $selectedApps += @{ Name = ".NET Desktop Runtime 8"; ID = "Microsoft.DotNet.DesktopRuntime.8"; Manager = "winget" } }
    if ($chkNet9.IsChecked) { $selectedApps += @{ Name = ".NET Desktop Runtime 9"; ID = "Microsoft.DotNet.DesktopRuntime.9"; Manager = "winget" } }
    if ($chkNet10.IsChecked) { $selectedApps += @{ Name = ".NET Desktop Runtime 10"; ID = "Microsoft.DotNet.DesktopRuntime.10"; Manager = "winget" } }
    if ($chkDirectX.IsChecked) { $selectedApps += @{ Name = "DirectX Runtime"; ID = "directx"; Manager = "choco" } }
    if ($chkJava.IsChecked) { $selectedApps += @{ Name = "Adoptium Java JDK"; ID = "EclipseAdoptium.Temurin.17.JDK"; Manager = "winget" } }
    
    # Developer Tools
    if ($chkVSCode.IsChecked) { $selectedApps += @{ Name = "VS Code"; ID = "Microsoft.VisualStudioCode"; Manager = "winget" } }
    if ($chkNotepad.IsChecked) { $selectedApps += @{ Name = "Notepad++"; ID = "Notepad++.Notepad++"; Manager = "winget" } }
    if ($chkPython.IsChecked) { $selectedApps += @{ Name = "Python 3"; ID = "Python.Python.3"; Manager = "winget" } }
    if ($chkGit.IsChecked) { $selectedApps += @{ Name = "Git"; ID = "Git.Git"; Manager = "winget" } }
    if ($chkFileZilla.IsChecked) { $selectedApps += @{ Name = "FileZilla Client"; ID = "TimKosse.FileZilla"; Manager = "winget" } }
    if ($chkGitHub.IsChecked) { $selectedApps += @{ Name = "GitHub Desktop"; ID = "GitHub.GitHubDesktop"; Manager = "winget" } }
    if ($chkNodeJS.IsChecked) { $selectedApps += @{ Name = "NodeJS (LTS)"; ID = "OpenJS.NodeJS.LTS"; Manager = "winget" } }
    if ($chkIntelliJ.IsChecked) { $selectedApps += @{ Name = "IntelliJ IDEA Community"; ID = "JetBrains.IntelliJIDEA.Community"; Manager = "winget" } }
    if ($chkPyCharm.IsChecked) { $selectedApps += @{ Name = "PyCharm Community"; ID = "JetBrains.PyCharm.Community"; Manager = "winget" } }
    if ($chkGo.IsChecked) { $selectedApps += @{ Name = "Go"; ID = "GoLang.Go"; Manager = "winget" } }
    if ($chkRust.IsChecked) { $selectedApps += @{ Name = "RustUp"; ID = "Rustlang.Rustup"; Manager = "winget" } }
    if ($chkNeovim.IsChecked) { $selectedApps += @{ Name = "Neovim"; ID = "Neovim.Neovim"; Manager = "winget" } }
    
    # Hardware & Pro Tools
    if ($chkCPUZ.IsChecked) { $selectedApps += @{ Name = "CPU-Z"; ID = "CPUID.CPU-Z"; Manager = "winget" } }
    if ($chkGPUZ.IsChecked) { $selectedApps += @{ Name = "GPU-Z"; ID = "TechPowerUp.GPU-Z"; Manager = "winget" } }
    if ($chkHWMonitor.IsChecked) { $selectedApps += @{ Name = "HWMonitor"; ID = "CPUID.HWMonitor"; Manager = "winget" } }
    if ($chkDDU.IsChecked) { $selectedApps += @{ Name = "Display Driver Uninstaller"; ID = "Wagnardsoft.DisplayDriverUninstaller"; Manager = "winget" } }
    if ($chkPowerToys.IsChecked) { $selectedApps += @{ Name = "Microsoft PowerToys"; ID = "Microsoft.PowerToys"; Manager = "winget" } }
    if ($chkTerminal.IsChecked) { $selectedApps += @{ Name = "Windows Terminal"; ID = "Microsoft.WindowsTerminal"; Manager = "winget" } }
    if ($chkWireshark.IsChecked) { $selectedApps += @{ Name = "Wireshark"; ID = "Wireshark.Wireshark"; Manager = "winget" } }
    if ($chkHWiNFO.IsChecked) { $selectedApps += @{ Name = "HWiNFO64"; ID = "REALiX.HWiNFO64"; Manager = "winget" } }
    if ($chkProcExp.IsChecked) { $selectedApps += @{ Name = "Process Explorer"; ID = "Microsoft.Sysinternals.ProcessExplorer"; Manager = "winget" } }
    if ($chkSysSuite.IsChecked) { $selectedApps += @{ Name = "Sysinternals Suite"; ID = "Microsoft.SysinternalsSuite"; Manager = "winget" } }
    if ($chkIpScanner.IsChecked) { $selectedApps += @{ Name = "Advanced IP Scanner"; ID = "Famatech.AdvancedIPScanner"; Manager = "winget" } }

    if ($selectedApps.Count -eq 0) {
        $lblInstallStatus.Text = "No apps selected!"
        $btnInstall.IsEnabled = $true
        return
    }

    $totalApps = $selectedApps.Count
    $pbProgress.Maximum = $totalApps
    $pbProgress.Value = 0
    $lblInstallStatus.Text = "Initializing installation..."

    # Create thread-safe synchronized hashtable for status reporting
    $sync = [hashtable]::Synchronized(@{ Status = "Initializing..."; Progress = 0 })

    # Installation code running inside in-process runspace
    $installBlock = {
        param($apps, $sync)
        
        function Get-WingetPath {
            if (Get-Command winget -ErrorAction SilentlyContinue) { return "winget" }
            $localPath = "$env:LOCALAPPDATA\Microsoft\WindowsApps\winget.exe"
            if (Test-Path $localPath) { return $localPath }
            try {
                $arch = if ([System.IntPtr]::Size -eq 8) { "x64" } else { "x86" }
                $winAppsPath = "$env:ProgramFiles\WindowsApps"
                if (Test-Path $winAppsPath) {
                    $resolved = Get-ChildItem -Path $winAppsPath -Filter "Microsoft.DesktopAppInstaller_*_${arch}__8wekyb3d8bbwe" -ErrorAction SilentlyContinue |
                                Sort-Object Name | Select-Object -Last 1
                    if ($resolved) {
                        $exePath = Join-Path $resolved.FullName "winget.exe"
                        if (Test-Path $exePath) { return $exePath }
                    }
                }
            } catch {}
            return $null
        }

        function Get-ChocoPath {
            if (Get-Command choco -ErrorAction SilentlyContinue) { return "choco" }
            $globalPath = "$env:ALLUSERSPROFILE\chocolatey\bin\choco.exe"
            if (Test-Path $globalPath) { return $globalPath }
            return $null
        }

        function Install-Winget {
            $sync.Status = "Winget not found. Installing Winget..."
            
            # 1. Attempt using Microsoft.WinGet.Client module (official method)
            try {
                $sync.Status = "Installing NuGet provider..."
                if (-not (Get-PackageProvider -Name NuGet -ListAvailable -ErrorAction SilentlyContinue)) {
                    Install-PackageProvider -Name "NuGet" -Force -ForceBootstrap -ErrorAction SilentlyContinue | Out-Null
                }
                
                $sync.Status = "Installing Microsoft.WinGet.Client..."
                Install-Module -Name Microsoft.WinGet.Client -Force -AllowClobber -Repository PSGallery -ErrorAction Stop | Out-Null
                
                $sync.Status = "Repairing/Installing WinGet..."
                Import-Module Microsoft.WinGet.Client -ErrorAction SilentlyContinue
                Repair-WinGetPackageManager -AllUsers -Force -Latest -ErrorAction Stop | Out-Null
                
                $w = Get-WingetPath
                if ($w) {
                    $sync.Status = "Winget installed via official module."
                    return
                }
            } catch {
                Write-Debug "Official module install failed: $_"
            }
            
            # 2. Fallback to manual download and installation
            $sync.Status = "Module install failed. Running fallback manual install..."
            $dir = "$env:TEMP\WingetInstaller"
            if (Test-Path $dir) { Remove-Item $dir -Recurse -Force -ErrorAction SilentlyContinue }
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
            
            $arch = if ([System.IntPtr]::Size -eq 8) { "x64" } else { "x86" }
            
            $vcLibsUrl = "https://aka.ms/Microsoft.VCLibs.$arch.14.00.Desktop.appx"
            $uiXamlUrl = "https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.$arch.appx"
            $wingetUrl = "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
            $licenseUrl = "https://github.com/microsoft/winget-cli/releases/latest/download/License1.xml"
            
            try {
                $sync.Status = "Downloading VC++ Runtimes..."
                Invoke-WebRequest -Uri $vcLibsUrl -OutFile "$dir\VCLibs.appx" -UseBasicParsing | Out-Null
                
                $sync.Status = "Downloading UI Xaml..."
                Invoke-WebRequest -Uri $uiXamlUrl -OutFile "$dir\UIXaml.appx" -UseBasicParsing | Out-Null
                
                $sync.Status = "Downloading Winget License..."
                Invoke-WebRequest -Uri $licenseUrl -OutFile "$dir\License.xml" -UseBasicParsing | Out-Null
                
                $sync.Status = "Downloading Winget Bundle..."
                Invoke-WebRequest -Uri $wingetUrl -OutFile "$dir\Winget.msixbundle" -UseBasicParsing | Out-Null
                
                $sync.Status = "Installing VC++ Runtimes..."
                Add-AppxPackage -Path "$dir\VCLibs.appx" -ErrorAction SilentlyContinue | Out-Null
                
                $sync.Status = "Installing UI Xaml..."
                Add-AppxPackage -Path "$dir\UIXaml.appx" -ErrorAction SilentlyContinue | Out-Null
                
                $sync.Status = "Installing Winget Package..."
                Add-AppxPackage -Path "$dir\Winget.msixbundle" -LicensePath "$dir\License.xml" -ErrorAction Stop | Out-Null
                
                $sync.Status = "Registering DesktopAppInstaller..."
                Add-AppxPackage -RegisterByFamilyName -MainPackage "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe" -ErrorAction SilentlyContinue | Out-Null
                
                if (-not ($env:PATH -split ';').Contains("$env:LOCALAPPDATA\Microsoft\WindowsApps")) {
                    $env:PATH += ";$env:LOCALAPPDATA\Microsoft\WindowsApps"
                }
                
                Start-Sleep -Seconds 5
            } catch {
                $sync.Status = "ERROR: Manual install failed: $_"
                throw $_
            } finally {
                Remove-Item $dir -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
            }
        }

        function Install-Chocolatey {
            $sync.Status = "Installing Chocolatey..."
            try {
                [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
                $scriptUrl = "https://community.chocolatey.org/install.ps1"
                $scriptContent = Invoke-RestMethod -Uri $scriptUrl -UseBasicParsing
                Invoke-Expression $scriptContent | Out-Null
                
                $chocoPath = "$env:ALLUSERSPROFILE\chocolatey\bin"
                if (Test-Path $chocoPath) {
                    if (-not ($env:PATH -split ';').Contains($chocoPath)) {
                        $env:PATH += ";$chocoPath"
                    }
                }
                $sync.Status = "Chocolatey installed successfully."
            } catch {
                $sync.Status = "ERROR: Failed to install Chocolatey: $_"
                throw $_
            }
        }

        # Setup Winget (if any winget apps are checked)
        $hasWingetApps = $apps | Where-Object { $_.Manager -eq "winget" }
        $winget = $null
        if ($hasWingetApps) {
            $winget = Get-WingetPath
            if (-not $winget) {
                try {
                    Install-Winget
                    $winget = Get-WingetPath
                } catch {
                    $sync.Status = "ERROR: Failed to install Winget: $_"
                }
            }
        }

        # Setup Chocolatey (if any choco apps are checked)
        $hasChocoApps = $apps | Where-Object { $_.Manager -eq "choco" }
        $choco = $null
        if ($hasChocoApps) {
            $choco = Get-ChocoPath
            if (-not $choco) {
                try {
                    Install-Chocolatey
                    $choco = Get-ChocoPath
                } catch {
                    $sync.Status = "ERROR: Failed to install Chocolatey: $_"
                }
            }
        }

        # Run Installations
        $count = 0
        foreach ($app in $apps) {
            $sync.Status = "Installing $($app.Name)..."
            
            if ($app.Manager -eq "winget") {
                if (-not $winget) {
                    $sync.Status = "ERROR: Winget is missing, skipping $($app.Name)."
                    $count++
                    $sync.Progress = $count
                    continue
                }
                $proc = Start-Process $winget -ArgumentList "install --id $($app.ID) --silent --accept-source-agreements --accept-package-agreements" -PassThru -NoNewWindow -Wait
                if ($proc.ExitCode -eq 0) {
                    $sync.Status = "SUCCESS: $($app.Name) installed."
                } else {
                    $sync.Status = "ERROR: Failed to install $($app.Name) (ExitCode: $($proc.ExitCode))."
                }
            }
            elseif ($app.Manager -eq "choco") {
                if (-not $choco) {
                    $sync.Status = "ERROR: Chocolatey is missing, skipping $($app.Name)."
                    $count++
                    $sync.Progress = $count
                    continue
                }
                
                # Special optimization for .NET Framework 3.5
                if ($app.ID -eq "dotnet3.5") {
                    $sync.Status = "Enabling .NET Framework 3.5 via DISM..."
                    $proc = Start-Process dism.exe -ArgumentList "/online /enable-feature /featurename:NetFx3 /all /norestart" -PassThru -NoNewWindow -Wait
                    if ($proc.ExitCode -eq 0) {
                        $sync.Status = "SUCCESS: .NET 3.5 enabled."
                    } else {
                        $sync.Status = "DISM failed. Retrying .NET 3.5 via Chocolatey..."
                        $proc = Start-Process $choco -ArgumentList "install $($app.ID) -y --no-progress" -PassThru -NoNewWindow -Wait
                        if ($proc.ExitCode -eq 0) {
                            $sync.Status = "SUCCESS: $($app.Name) installed."
                        } else {
                            $sync.Status = "ERROR: Failed to install $($app.Name) (ExitCode: $($proc.ExitCode))."
                        }
                    }
                } else {
                    $proc = Start-Process $choco -ArgumentList "install $($app.ID) -y --no-progress" -PassThru -NoNewWindow -Wait
                    if ($proc.ExitCode -eq 0) {
                        $sync.Status = "SUCCESS: $($app.Name) installed."
                    } else {
                        $sync.Status = "ERROR: Failed to install $($app.Name) (ExitCode: $($proc.ExitCode))."
                    }
                }
            }
            
            $count++
            $sync.Progress = $count
        }
        $sync.Status = "All tasks completed!"
    }

    $ps = [PowerShell]::Create()
    [void]$ps.AddScript($installBlock)
    [void]$ps.AddArgument($selectedApps)
    [void]$ps.AddArgument($sync)
    $asyncResult = $ps.BeginInvoke()

    # Monitor runspace in UI
    $timer = New-Object System.Windows.Threading.DispatcherTimer
    $timer.Interval = [TimeSpan]::FromMilliseconds(150)
    $timer.Add_Tick({
        $lblInstallStatus.Text = $sync.Status
        $pbProgress.Value = $sync.Progress
        
        if ($asyncResult.IsCompleted) {
            $timer.Stop()
            try { $ps.EndInvoke($asyncResult) | Out-Null } catch {}
            $ps.Dispose()
            $btnInstall.IsEnabled = $true
        }
    })
    $timer.Start()
})

# Show the window
$window.ShowDialog() | Out-Null
