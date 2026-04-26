[![CI](https://github.com/Tdebo21/avd_manager/actions/workflows/ci.yml/badge.svg)](https://github.com/Tdebo21/avd_manager/actions)
[![pub package](https://img.shields.io/pub/v/avd_manager.svg)](https://pub.dev/packages/avd_manager)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-%E2%98%95-yellow)](https://buymeacoffee.com/guimbobabag)
[![GitHub Sponsors](https://img.shields.io/github/sponsors/Tdebo21?label=Sponsor&style=social)](https://github.com/sponsors/Tdebo21)


# 📱 avdm - AVD Manager CLI Tool

**avdm** is a simple and efficient command-line tool that helps you manage Android Virtual Devices (AVDs) right from your terminal.

Built for developers who want a faster, scriptable, and more minimal alternative to Android Studio’s GUI-based AVD Manager.

---

## 🚀 Features

- 🔍 List all available AVDs
- 📦 Show disk usage per AVD
- 📊 Sort AVDs by name or size
- 📏 Filter AVDs by minimum size (e.g. `--min-size 2GB`)
- ⚡ Lightweight & fast (written in Dart)

---

## 📦 Installation

> Ensure you have the Dart SDK installed. If not, install it from https://dart.dev/get-dart

### 1. Clone the repo

```bash
git clone https://github.com/Tdebo21/avd_manager.git
cd avd_manager
```

### 2. Activate the CLI

dart pub global activate --source path .

> This makes avdm available globally as a command.
>
> If you previously installed `avdm`, refresh the global install with:
>
> ```bash
dart pub global deactivate avd_manager
dart pub global activate --source path .
```


## 🛠 Usage

```bash
avdm <command> [options]


# 📋 Available Commands
Command	Description
list	List all AVDs with optional sort/filter
create	Create a new AVD from a system image
patch	Patch an existing AVD (config changes)
launch	Launch a specific AVD
delete	Delete a specific AVD
help	Show help Options

# 🔧 Options for list
Flag	Description	Example
--sort	Sort AVDs by name or size	--sort size
--min-size	Only show AVDs larger than given size  --min-size 1GB


# Examples

# List all AVDs
avdm list

> Note: `avdm list` reports the size of each AVD's local `.avd` directory. Newly created AVDs often start very small (around 1MB) and grow after the emulator is launched and the AVD image files are created.

# Sort AVDs by size
avdm list --sort size

# Filter AVDs larger than 2GB
avdm list --min-size 2GB

# Sort AVDs by name and filter by minimum size
avdm list --sort name --min-size 1GB

# Create a new AVD
avdm create <avd_name> --device "Pixel 2" --api 30
# Examples:
avdm create Slim_API30 --api=30
avdm create TestDevice --device="Nexus 4" --api=29
avdm create miniTestPhone --device "pixel" --api 30 --abi arm64-v8a

> On Apple Silicon, the tool now defaults `--abi` to `arm64-v8a` when not provided. Use `--abi x86` or `--abi x86_64` only if you have Intel system images installed.

Prompt-based selection:
avdm launch

# Launch specific AVD with defaults:
avdm launch TestDevice

# Launch with performance flags:
avdm launch TestDevice --cold-boot --no-boot-anim --no-snapshot-load
avdm launch TestDevice --no-snapshot-save
Use "avdm <command> --help" for more information about a command.

# Delete an AVD
avdm delete Slim_API30


# 🧩 How It Works

avdm looks for AVDs in your $ANDROID_AVD_HOME environment variable.

If not set, it defaults to ~/.android/avd/.

It reads each AVD’s directory and calculates its total disk usage.

Outputs the AVD name and its formatted size (e.g. 1.94 GB).

# 🤝 Contributing

Contributions, suggestions, and bug reports are welcome!

Fork the repo

Create your feature branch: git checkout -b my-feature

Commit your changes: git commit -m 'Add awesome feature'

Push to the branch: git push origin my-feature

Open a pull request

# 📝 License

This project is licensed under the MIT License. See the LICENSE
 file for details.

# ❤️ Support & Sponsorship

If you found this project useful, consider sponsoring it to support further development!

💖 Sponsor on GitHub https://github.com/sponsors/Tdebo21

Or buy me a coffee: https://www.buymeacoffee.com/guimbobabag

# ✨ Author

Rabi Iya
GitHub @Tdebo21

