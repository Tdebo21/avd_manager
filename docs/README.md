# 📱 avdm - AVD Manager CLI

A lightweight tool to create, patch, delete, and launch Android Virtual Devices (AVDs) from the terminal.

## 🚀 Getting Started

# Install from pub.dev

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

- `avdm list` – Show available AVDs
- `avdm create` – Create a new AVD
- `avdm launch` – Start a virtual device
- `avdm delete` – Remove an AVD
- `avdm --help - get help

See full command docs in the sidebar.

---
