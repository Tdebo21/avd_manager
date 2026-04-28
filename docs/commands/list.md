# 📋 List AVDs

The `list` command shows all available Android Virtual Devices (AVDs) on your system.

## 🔧 Usage

```bash
avdm list [--sort name|size] [--min-size 1GB]
```

## 🏷 Options

| Flag         | Description                                        |
| ------------ | -------------------------------------------------- |
| `--sort`     | Sort AVDs by `name` or `size`                      |
| `--min-size` | Show only AVDs larger than given size (e.g. `2GB`) |

## ✅ Examples

```bash
# List all AVDs
avdm list

# List and sort by size
avdm list --sort size

# List only AVDs > 2GB
avdm list --min-size 2GB

# List and sort by name
avdm list --sort name
```
