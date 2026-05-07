#!/usr/bin/env node
const os = require("os");
const path = require("path");
const { spawn } = require("child_process");

const platform = os.platform();
let binary = "";

if (platform === "darwin") binary = "avdm-macos";
else if (platform === "win32") binary = "avdm-win.exe";
else binary = "avdm-linux";

const binPath = path.join(__dirname, "bin", binary);

const child = spawn(binPath, process.argv.slice(2), { stdio: "inherit" });
child.on("exit", (code) => process.exit(code));
