const fs = require("fs");
const path = require("path");

try {
  // Read version from package.json
  const packageJsonPath = path.join(process.cwd(), "package.json");
  const packageJson = JSON.parse(fs.readFileSync(packageJsonPath, "utf8"));
  const version = packageJson.version;

  if (!version) {
    throw new Error("No version found in package.json");
  }

  // Update pubspec.yaml
  const pubspecPath = path.join(process.cwd(), "pubspec.yaml");

  if (!fs.existsSync(pubspecPath)) {
    throw new Error(`pubspec.yaml not found at ${pubspecPath}`);
  }

  let pubspec = fs.readFileSync(pubspecPath, "utf8");
  const originalPubspec = pubspec;

  // Replace version line (handles different spacing)
  pubspec = pubspec.replace(/^version:\s+.+$/m, `version: ${version}`);

  // Verify the replacement actually happened
  if (pubspec === originalPubspec) {
    throw new Error(
      "Failed to update version in pubspec.yaml - pattern not found",
    );
  }

  fs.writeFileSync(pubspecPath, pubspec);
  console.log(`✓ Synced version to ${version} in pubspec.yaml`);
} catch (error) {
  console.error(`✗ Error syncing versions: ${error.message}`);
  process.exit(1);
}
