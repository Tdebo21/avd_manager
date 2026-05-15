const fs = require("fs");
const path = require("path");

// Read the new version from root package.json
const rootPackageJsonPath = path.join(__dirname, "../package.json");
const rootPackageJson = JSON.parse(
  fs.readFileSync(rootPackageJsonPath, "utf-8"),
);
const newVersion = rootPackageJson.version;

console.log(`\n📦 Verifying version sync to ${newVersion}...\n`);

// Verify pubspec.yaml
const pubspecPath = path.join(__dirname, "../pubspec.yaml");
const pubspecContent = fs.readFileSync(pubspecPath, "utf-8");
const pubspecHasVersion = pubspecContent.includes(`version: ${newVersion}`);
console.log(
  `${pubspecHasVersion ? "✅" : "❌"} pubspec.yaml: ${pubspecHasVersion ? `v${newVersion}` : "MISMATCH"}`,
);

// Verify npm/package.json
const npmPackageJsonPath = path.join(__dirname, "../npm/package.json");
const npmPackageJson = JSON.parse(fs.readFileSync(npmPackageJsonPath, "utf-8"));
const npmHasVersion = npmPackageJson.version === newVersion;
console.log(
  `${npmHasVersion ? "✅" : "❌"} npm/package.json: ${npmHasVersion ? `v${newVersion}` : `v${npmPackageJson.version} (MISMATCH)`}`,
);

if (!pubspecHasVersion || !npmHasVersion) {
  console.error("\n❌ Version mismatch detected!");
  process.exit(1);
}

console.log("\n✨ All versions synchronized!\n");
