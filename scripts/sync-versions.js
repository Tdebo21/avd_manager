const fs = require("fs");
const path = require("path");

// Read version from package.json
const packageJson = JSON.parse(fs.readFileSync("package.json", "utf8"));
const version = packageJson.version;

// Update pubspec.yaml
let pubspec = fs.readFileSync("pubspec.yaml", "utf8");
pubspec = pubspec.replace(/^version: .+$/m, `version: ${version}`);
fs.writeFileSync("pubspec.yaml", pubspec);

console.log(`✓ Synced version to ${version} in pubspec.yaml`);
