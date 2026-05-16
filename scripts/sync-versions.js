const fs = require("fs");
const path = require("path");
const { execSync } = require("child_process");

// Read the new version from root package.json
const rootPackageJsonPath = path.join(__dirname, "../package.json");
const rootPackageJson = JSON.parse(
  fs.readFileSync(rootPackageJsonPath, "utf-8"),
);
const newVersion = rootPackageJson.version;

console.log(`\n📦 Syncing version to ${newVersion}...\n`);

// Update pubspec.yaml
const pubspecPath = path.join(__dirname, "../pubspec.yaml");
try {
  let pubspecContent = fs.readFileSync(pubspecPath, "utf-8");
  const originalContent = pubspecContent;
  pubspecContent = pubspecContent.replace(
    /version:\s+[0-9.]+/,
    `version: ${newVersion}`,
  );
  fs.writeFileSync(pubspecPath, pubspecContent, "utf-8");
  console.log(`✅ Updated pubspec.yaml to v${newVersion}`);

  // Stage pubspec.yaml for commit
  try {
    execSync("git add pubspec.yaml", { stdio: "pipe" });
    console.log(`✅ Staged pubspec.yaml for commit`);
  } catch (gitError) {
    console.warn(`⚠️  Could not stage pubspec.yaml (might be in dry-run mode)`);
  }
} catch (error) {
  console.error(`❌ Failed to update pubspec.yaml:`, error.message);
  process.exit(1);
}

// Verify npm/package.json was bumped correctly
const npmPackageJsonPath = path.join(__dirname, "../npm/package.json");
const npmPackageJson = JSON.parse(fs.readFileSync(npmPackageJsonPath, "utf-8"));
const npmHasVersion = npmPackageJson.version === newVersion;
console.log(
  `${npmHasVersion ? "✅" : "❌"} npm/package.json: v${npmPackageJson.version}`,
);

if (!npmHasVersion) {
  console.error("\n❌ Version mismatch in npm/package.json!");
  process.exit(1);
}

console.log("\n✨ All versions synchronized!\n");
