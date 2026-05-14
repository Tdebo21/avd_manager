[![npm version](https://img.shields.io/npm/v/avd-manager-cli.svg)](https://www.npmjs.com/package/avd-manager-cli)
[![downloads](https://img.shields.io/npm/dm/avd-manager-cli.svg)](https://www.npmjs.com/package/avd-manager-cli)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Last Updated](https://img.shields.io/github/last-commit/Tdebo21/avd_manager.svg)](https://github.com/Tdebo21/avd_manager/commits)
[![CI](https://github.com/Tdebo21/avd_manager/actions/workflows/ci.yml/badge.svg)](https://github.com/Tdebo21/avd_manager/actions)
[![pub package](https://img.shields.io/pub/v/avd_manager.svg)](https://pub.dev/packages/avd_manager)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-%E2%98%95-yellow)](https://buymeacoffee.com/guimbobabag)
[![Sponsor](https://img.shields.io/badge/sponsor-GitHub-blue)](https://github.com/sponsors/Tdebo21)

# 📱 avdm - AVD Manager CLI Tool

**avdm** is a simple and efficient command-line tool that helps you manage Android Virtual Devices (AVDs) right from your terminal.

Built for developers who want a faster, scriptable, and more minimal alternative to Android Studio’s GUI-based AVD Manager.

---

## 🚀 Features

- ✨ Create and manage Android Virtual Devices with ease
- 🔍 List all available AVDs and their configurations
- 🔧 Launch AVDs with custom options
- 📋 Delete and clean up unused or outdated AVDs
- 📦 Show disk usage per AVD
- 📊 Sort AVDs by name or size
- 📏 Filter AVDs by minimum size (e.g. `--min-size 2GB`)
- ⚡ Lightweight & fast (written in Dart)
- No GUI required

---

## 📦 Installation

**Option 1: Via Pub.dev (requires Dart SDK)**

### Prerequisites

> Ensure you have the Dart SDK installed. If not, install it from https://dart.dev/get-dart

- **Dart SDK** 3.0 or higher ([Install Dart](https://dart.dev/get-dart))
- **Android SDK** with emulator tools ([Install Android Studio](https://developer.android.com/studio))
- **Java JDK** 11 or higher

```bash
dart pub global activate avd_manager
avdm --help
```

### 1. Clone the repo

```bash
git clone https://github.com/Tdebo21/avd_manager.git
cd avd_manager
```

### 2. Activate the CLI

```bash
dart pub global activate --source path .
```

> This makes avdm available globally as a command.
>
> If you previously installed `avdm`, refresh the global install with:

```bash
dart pub global deactivate avdm
dart pub global activate --source path .
```

---

**Option 2: Download Binary (no Dart Required)**

> Optionally, you can install **AVD Manager CLI Tool** by downloading the binary from the releases page.

**Option 3: Using npm**
You can install AVD Manager CLI globally using npm:

```bash
npm install -g avd-manager-cli
```

**Option 4: Using Homebrew**

```bash
# Example installation using Homebrew (macOS)

brew tap Tdebo21/avd_manager
brew install avd_manager
```

## 🛠 Usage

```bash
avdm <command> [options]
```

### 📋 Available Commands

| Command  | Description                             |
| -------- | --------------------------------------- |
| `list`   | List all AVDs with optional sort/filter |
| `create` | Create a new AVD from a system image    |
| `patch`  | Patch an existing AVD (config changes)  |
| `launch` | Launch a specific AVD                   |
| `delete` | Delete a specific AVD                   |
| `help`   | Show help                               |

### 🔧 Options for `list`

| Flag         | Description                           | Example          |
| ------------ | ------------------------------------- | ---------------- |
| `--sort`     | Sort AVDs by `name` or `size`         | `--sort size`    |
| `--min-size` | Only show AVDs larger than given size | `--min-size 1GB` |

# Usage Examples

# List all AVDs

```bash
avdm list
```

> Note: `avdm list` reports the size of each AVD's local `.avd` directory. Newly created AVDs often
> start very small (around 1MB) and grow after the emulator is launched and the AVD image files are
> created.

# Sort AVDs by size

```bash
avdm list --sort size
```

# Filter AVDs larger than 2GB

```bash
avdm list --min-size 2GB
```

# Sort AVDs by name and filter by minimum size

```bash
avdm list --sort name --min-size 1GB
```

# Create a new AVD

```bash
avdm create <avd_name> --device "Pixel 2" --api 30
```

# Examples:

```bash
avdm create Slim_API30 --api=30
avdm create TestDevice --device="Nexus 4" --api=29
avdm create miniTestPhone --device "pixel" --api 30 --abi arm64-v8a
```

> On Apple Silicon, the tool now defaults `--abi` to `arm64-v8a` when not provided. Use `--abi x86` or `--abi x86_64` only if you have Intel system images installed.

# Launch AVD with prompt-based selection:

```bash
avdm launch
```

# Launch specific AVD with defaults:

```bash
avdm launch TestDevice
```

# Launch with performance flags:

```bash
avdm launch TestDevice --cold-boot --no-boot-anim --no-snapshot-load
avdm launch TestDevice --no-snapshot-save
```

> Use "avdm <command> --help" for more information about a command.

# Delete an AVD

```bash
avdm delete Slim_API30
```

---

# 🧩 How It Works

avdm looks for AVDs in your $ANDROID_AVD_HOME environment variable.

If not set, it defaults to ~/.android/avd/.

It reads each AVD’s directory and calculates its total disk usage.

Outputs the AVD name and its formatted size (e.g. 1.94 GB).

---

## Troubleshooting

### AVD Not Found

Ensure your `ANDROID_SDK_ROOT` environment variable is set:

```bash
# macOS/Linux
export ANDROID_SDK_ROOT=~/Library/Android/sdk  # macOS
export ANDROID_SDK_ROOT=~/Android/sdk  # Linux

# Windows (PowerShell)
$env:ANDROID_SDK_ROOT="C:\Users\YourName\AppData\Local\Android\sdk"
```

### Permission Denied (Linux/macOS)

Ensure the tool has execute permissions:

```bash
chmod +x ~/.pub-cache/bin/avdm
```

### Emulator Won't Launch

- Check that your system supports virtualization (KVM on Linux, Hypervisor Framework on macOS)
- Increase available RAM
- Disable VT-x/AMD-V in BIOS if conflicts exist

---

# 🤝 Contributing

Contributions, suggestions, and bug reports are welcome!

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -am 'Add awesome feature'`
4. Push to the branch: `git push origin feature/your-feature`
5. Open a Pull Request

---

# 📝 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history and release notes.

---

# ❤️ Support & Sponsorship

If you found this project useful, consider sponsoring it to support further development!

💖 Sponsor on GitHub: [![Sponsor](https://img.shields.io/badge/sponsor-GitHub-blue)](https://github.com/sponsors/Tdebo21)

Or buy me a coffee: [![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-%E2%98%95-yellow)](https://buymeacoffee.com/guimbobabag)

# ✨ Author

Rabi Iya
GitHub @Tdebo21
