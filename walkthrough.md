# ArgusOS Playbook Walkthrough

We have successfully rebranded, optimized, and packaged your custom **ArgusOS Playbook (v1.0)**! It is saved in your Downloads folder as [ArgusOS.apbx](file:///C:/Users/ArgusOs/Downloads/ArgusOS.apbx) (password: `malte`).

Below is a detailed summary of what was accomplished and how to deploy it.

---

## 🛠️ Summary of Changes

### 1. Rebranding to ArgusOS
* **`playbook.conf`**: Rebranded all metadata including name, description, title, support URL, and features to **ArgusOS**.
* **`custom.yml`**: Rebranded OEM info (`Manufacturer: ArgusOS`), drive label (`ArgusOS`), and boot description (`ArgusOS-Playbook-V1.0`).
* **Shell Scripts**: Rebranded custom Windows context-menu power plans (`ArgusOS Power Plan` in `laptop-desktop.bat`) and spoofed region registry backup keys (`ArgusOS_SavedNation` in `RemoveEdge.ps1`).

### 2. Browser Crash Fix (Mitigation Option Restored)
* **Playbook Updates**: Removed the playbook block from `custom.yml` that disabled system-wide process mitigations globally, and commented out the registry keys (`EnableSvchostMitigationPolicy` and `EnableSvchostMitigationsPolicy` under `HKLM\SYSTEM\CurrentControlSet\Control\SCMConfig`) that disabled service host (svchost) mitigations. Disabling these is highly unstable and causes Chromium-based browsers (like Chrome, Brave, Edge) and Electron apps (like OpenCode, Discord) to crash instantly on launch with `STATUS_BREAKPOINT`.
* **Live System Fix**: Instantly cleared the live system's registry overrides (`MitigationOptions`/`MitigationAuditOptions` and `EnableSvchostMitigationPolicy`/`EnableSvchostMitigationsPolicy`), fully restoring Windows Security defaults. Once the user reboots the PC, these settings will take effect in memory, preventing future crashes of OpenCode and Discord.

### 3. Custom Honeycomb Wallpaper & Icon Assets
* **Wallpaper**: Integrated the high-resolution (8K) version of your chosen **ArgusOS Honeycomb wallpaper** (featuring the custom cyan glowing "A" with the eye logo, and the metallic title). Set it as both the Desktop background and Lock screen.
* **Toolkit Icon**: Cropped the stylized cyan "A" eye logo directly from the center of the wallpaper, resized it to 256x256, and converted it to a high-quality Windows `.ico` file. This is embedded directly inside the compiled executable and used for its shortcuts.

### 4. Compiled Argus Toolkit Executable (`Argus-Toolkit.exe`)
Replaced the old `XOS-Toolkit-Setup.exe` with a custom standalone compiled executable (**`Argus-Toolkit.exe`**) written in PowerShell WPF/XAML and compiled using `ps2exe` with the UAC admin manifest embedded.
* **No script blockages**: Runs natively as a standard `.exe` file, avoiding Windows execution policy restrictions or opening in text editors.
* **Embedded Custom Icon**: Features the beautiful neon "A" eye logo directly on the executable file and all its shortcuts.
* **Modern Neon UI**: Re-designed the interface with a clean single-window dark-mode design, optimized for visual aesthetics with neon cyan highlight elements.
* **Expanded App Installer (Ninite/WinUtil Equivalent)**:
  * Automatically installs chosen apps silently using `winget` or `chocolatey`.
  * **Chocolatey Integration**: Automatically bootstraps and installs Chocolatey silently if missing, leveraging it to run complex runtime installers.
  * **Self-Installing Winget**: If `winget` is missing on your system, the toolkit automatically installs it with a dual-method fallback (.msixbundle installer or NuGet client module), configuring the PATH immediately without requiring a reboot.
  * **Supported Applications & Runtimes (82 options across 3 balanced columns)**:
    * *Web Browsers*: Chrome, Brave, Firefox, Opera, Opera GX, Edge, LibreWolf, Vivaldi, Tor Browser, Waterfox
    * *Game Launchers & Platforms*: Steam, Epic Games, Ubisoft Connect, EA Desktop, GOG Galaxy, GeForce NOW, Itch.io, Prism Launcher, Modrinth App
    * *Messaging*: Discord, Telegram Desktop, Zoom, Teams, Signal, Slack, Viber, Element, Skype
    * *Media & Creation*: VLC, Spotify, iTunes, AIMP Player, OBS Studio, GIMP, Paint.NET, Audacity, Blender, HandBrake, ImageGlass, Calibre
    * *Compression*: 7-Zip, WinRAR, PeaZip
    * *Runtimes & Frameworks*: VC++ Redist Runtimes AIO (Choco), .NET Framework 3.5 (AIO via DISM with Choco fallback), .NET Framework 4.8 (Choco), .NET Desktop Runtime (8, 9, 10), DirectX End-User Runtime (Choco), Adoptium Java JDK
    * *General Utilities*: Revo Uninstaller, WizTree Disk Analyzer, AnyDesk, qBittorrent, RustDesk, Rufus, Ventoy, BleachBit
    * *Developer Tools*: VS Code, Notepad++, Python 3, Git, FileZilla, GitHub Desktop, NodeJS (LTS), IntelliJ IDEA, PyCharm, Go, RustUp, Neovim
    * *Hardware & Pro Tools*: CPU-Z, GPU-Z, HWMonitor, Display Driver Uninstaller (DDU), Microsoft PowerToys, Windows Terminal, Wireshark, HWiNFO64, Process Explorer, Sysinternals Suite, Advanced IP Scanner

---

## 🚀 Deployment Instructions

### Step 1: Run the Playbook via AME Wizard
1. Open **AME Wizard** on your PC.
2. Drag and drop or import the [ArgusOS.apbx](file:///C:/Users/ArgusOs/Downloads/ArgusOS.apbx) playbook from your Downloads folder.
3. Use the playbook decryption password: `malte`
4. Follow the customizable configuration options (e.g., disable/keep Defender, remove/keep Edge, disable/keep printing).
5. Run the installation and let it finish (it will automatically reboot your system at the end).

### Step 2: Use the Argus Toolkit
* Once Windows boots, you will find an **Argus Toolkit** shortcut on your Desktop and in the Start Menu.
* Double-click it (it will automatically prompt for administrator privileges) to open the custom panel.
* Select the apps and runtimes you want to install and click **Install Selected**.
* Monitor installation status and progress directly through the unified status bar.
