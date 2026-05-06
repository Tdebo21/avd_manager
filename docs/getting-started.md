# Getting Started

Welcome to **AVD Manager CLI** — a simple and efficient command-line tool for managing Android Virtual Devices (AVDs) directly from your terminal.

This quick-start guide will help you install, configure, and use the CLI in just a few steps.

---

## 🧩 Prerequisites

Before you begin, make sure you have:

- **Android SDK** installed
- **Java JDK 11+**
- **Android SDK tools** (`avdmanager`, `sdkmanager`) available in your PATH
- **Node.js** (if installing via npm)
- **Homebrew** (if installing via Homebrew)

---

## ⚙️ Installation

You can install AVD Manager CLI globally using npm:

```bash
npm install -g avd_manager
```

Or clone the repository manually:

```bash
git clone https://github.com/Tdbo21/avd_manager.git
cd avd_manager
npm install
```

## 🚀 First Run

After installation, verify the CLI is working:

```bash
avdm --help
```

You should see a list of available commands and their usage.

## 🧭 Common Commands

| Command                                                  | Description              |
| -------------------------------------------------------- | ------------------------ |
| `avdm `list                                              | Lists all available AVDs |
| `avdm `create `Pixel_API_35 `--device `pixel `--api `35` | Creates a new AVD        |
| `avdm `delete `Pixel_API_35`                             | Deletes an existing AVD  |
| `avdm `launch `Pixel_API_35`                             | Launches an existing AVD |

## 🧪 Example Workflow

List existing AVDs

```bash
avdm list
```

Create a new AVD

```bash
avdm create Pixel_API_35 --device pixel --api 35
```

Delete an AVD

```bash
avdm delete Pixel_API_35
```

Launch an AVD

```bash
avdm launch Pixel_API_35
```

## 🧰 Troubleshooting

If you encounter issues:

- Ensure your Android SDK path is correctly set
- Check permissions for the .android directory

## 🧩 Next Steps

- Explore the [README](README.md)section for detailed usage
- Visit the GitHub Repository - [![GitHub](https://img.shields.io/badge/GitHub-avd_manager-blue)](https://github.com/Tdebo21/avd_manager)
- Contribute or open issues to improve the tool
