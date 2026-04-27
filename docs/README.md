# 📱 avdm - AVD Manager CLI

A lightweight DART CLI tool for managing Android Virtual Devices with ease.

## Features

- ✨ Create and manage AVDs programmatically
- 🚀 List available AVDs and their sizes
- 🔧 Launch AVDs with custom options
- 📋 Delete and clean up unused AVDs
- 🎯 Cross-platform support (macOS, Windows, Linux)

## Quick Start

### Prerequisites

- **Dart SDK** 3.0 or higher ([Install Dart](https://dart.dev/get-dart))
- **Android SDK** with emulator tools ([Install Android Studio](https://developer.android.com/studio))
- **Java JDK** 11 or higher

### macOS

```bash
# Install from pub.dev
dart pub global activate avdm

# Verify installation
avdm --version
```

### Windows

```powershell
# Using pub.dev
dart pub global activate avdm

# Add Dart global bin to PATH if not already done:
# %APPDATA%\Pub\Cache\bin

# Verify installation
avdm --version
```

### Linux

```bash
# Using pub.dev
dart pub global activate avdm

# Add Dart global bin to PATH (usually automatic, but verify):
# ~/.pub-cache/bin

# Verify installation
avdm --version
```

## 🛠 Available Commands

See the sidebar for detailed command documentation.

- **[list](commands/list.md)** – Show available AVDs
- **[create](commands/create.md)** – Create a new AVD
- **[launch](commands/launch.md)** – Start a virtual device
- **[delete](commands/delete.md)** – Remove an AVD

## License

MIT License - See [LICENSE](https://github.com/Tdebo21/avd_manager/blob/main/LICENSE)

## Usage

```bash
avdm list [options]
```

## Options

- `--sort [size|name]` - Sort AVDs by size or name
- `--min-size <size>` - Only show AVDs larger than this size (e.g., 500MB, 1GB)
- `-h, --help` - Show help information

## Examples

```bash
# List all AVDs
avdm list

# Sort by name
avdm list --sort name

# Filter by minimum size
avdm list --min-size 1GB
```
