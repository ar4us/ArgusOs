# ArgusOS Playbook & Toolkit

Welcome to **ArgusOS**, a highly optimized custom Windows operating system configuration designed for gaming and power users. This repository contains the custom AME Wizard Playbook source, the compiled playbook archive, and the custom Argus Toolkit utility.

## ðŸ“ Repository Structure

- **playbook/**: Source configuration files of the ArgusOS Playbook (AME Wizard format).
  - Includes custom Honeycomb wallpapers, Start menu layouts, and customized debloating settings.
- **	oolkit/**: Source code and compilation scripts for the custom WPF-based **Argus Toolkit**.
  - Argus-Toolkit.ps1: The main PowerShell/WPF script backend.
  - compile_toolkit.ps1: Automated build pipeline to compile the PowerShell script to a standalone .exe.
  - ebuild_playbook.ps1: Moves custom assets (wallpaper, icon, toolkit executable) into the playbook folder.
- **ArgusOS.apbx**: The compiled, ready-to-run playbook archive for AME Wizard (Decryption Password: malte).
- **Argus-Toolkit.exe**: The compiled, standalone application for silent software installation via winget and chocolatey.
- **walkthrough.md**: Detailed system architecture modifications, customizations, and deployment instructions.
- **	ask.md**: Implementation checklist and milestone tracking.

## ðŸ› ï¸ Main Features

### 1. ArgusOS Playbook
- **Visual Rebranding**: Custom OEM labels, drive letters, boot entries, and a stunning 8K glowing cyan Honeycomb theme wallpaper for Desktop and Lock Screen.
- **Performance Optimizations**: Debloated default apps, disabled non-essential services, optimized kernel/scheduler settings for gaming latency, and disabled system-wide telemetry.
- **Exploit Mitigations Fixed**: Disabling kernel mitigations system-wide is unstable for Chromium-based browsers and Electron apps (which crash instantly on launch with STATUS_BREAKPOINT). This playbook **keeps system process mitigations and DEP enabled by default**, ensuring browsers (Chrome, Brave, Edge) and desktop clients (Discord, OpenCode) function perfectly.

### 2. Argus Toolkit
- **Custom Neon WPF Interface**: A premium dark-theme dashboard styled with glowing neon cyan accents.
- **App Installer (82+ apps & runtimes)**: Single-click silent deployment of browsers, launchers, messaging apps, utilities, dev tools, and gaming hardware diagnostics.
- **Chocolatey & Winget Integration**: Automatically bootstraps Chocolatey if missing, leveraging it for complex runtime packages (Adoptium Java JDK, DirectX Runtime, Visual C++ Runtimes All-in-One, and .NET Frameworks).

## ðŸš€ How to Install

### Step 1: Run the Playbook via AME Wizard
1. Download [ArgusOS.apbx](ArgusOS.apbx) from this repository.
2. Open **AME Wizard** on your PC.
3. Drag and drop ArgusOS.apbx into AME Wizard.
4. Enter the password: malte
5. Customize features (Defender, Edge, printing options) and run the install.
6. The system will reboot automatically when done.

### Step 2: Install Apps using Argus Toolkit
1. Once booted, run **Argus-Toolkit.exe** (requires Administrator privileges).
2. Select the applications you want to install.
3. Click **Install Selected** and watch the synchronous logging status bar update in real-time.

---
*Created by [ar4us](https://github.com/ar4us) | Powered by AME Wizard and custom WPF automation.*
