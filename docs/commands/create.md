# 🛠 Create AVD

The `create` command sets up a new Android Virtual Device using a given system image and name.

## 🔧 Usage

```bash
avdm create <avd-name> --api image "<system-image>"
````

## 🏷 Options

| Flag      | Description                            |
| --------- | -------------------------------------- |
| `--api`  | API level (e.g. 28)                  |
| `--abi` | ABI for the system image (e.g. x86, x86_64, arm64-v8a) |

✅ **Tip:** Use `sdkmanager --list` to find available system images.

## ✅ Example

```bash
 avdm create Pixel_24 --api=24 image "system-images;android-24;google_apis;x86_64"
```
