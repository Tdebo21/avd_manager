import 'dart:io';
import 'package:avd_manager/avd_utils.dart';

Future<List<String>> listAvailableDevices() async {
  final result = await runAvdManager(['list', 'device']);
  if (result.exitCode != 0) {
    print('❌ Failed to list devices');
    return [];
  }

  final devices = <String>[];
  final regex = RegExp(r'id: \d+ or "(.*?)"');
  for (final line in result.stdout.toString().split('\n')) {
    final match = regex.firstMatch(line);
    if (match != null) {
      devices.add(match.group(1)!);
    }
  }

  if (devices.isEmpty) {
    print('⚠️ No devices found.');
    return [];
  }
  return devices;
}

Future<String?> promptForDevice(List<String> devices) async {
  print('\n📱 Available Devices:\n');
  for (int i = 0; i < devices.length; i++) {
    print('  [${i + 1}] ${devices[i]}');
  }
  stdout.write('\nEnter device number: ');
  final input = stdin.readLineSync();
  final index = int.tryParse(input ?? '');
  if (index != null && index > 0 && index <= devices.length) {
    return devices[index - 1];
  }
  print('❌ Invalid selection.');
  return null;
}

Future<void> createAvd(String name,
    {String? device, required String apiLevel, String? abi}) async {
  final systemImage = await _getSystemImage(apiLevel, abi: abi);

  device ??= await _selectDevice();
  if (device == null) {
    print('❌ No device selected.');
    return;
  }

  await createAndPatchAvd(name, device: device, systemImage: systemImage);
}

Future<String> _getSystemImage(String apiLevel, {String? abi}) async {
  final selectedAbi = abi ?? await _resolveDefaultAbi();

  if (selectedAbi.isEmpty) {
    return 'system-images;android-$apiLevel;google_apis;x86';
  }

  return 'system-images;android-$apiLevel;google_apis;$selectedAbi';
}

Future<String> _resolveDefaultAbi() async {
  try {
    final result = await Process.run('uname', ['-m']);
    final hostArch = result.stdout.toString().trim().toLowerCase();
    if (hostArch == 'arm64' || hostArch == 'aarch64') {
      return 'arm64-v8a';
    }
    if (hostArch == 'x86_64' || hostArch == 'amd64') {
      return 'x86';
    }
  } catch (_) {
    // ignore and fall back to x86
  }

  return 'x86';
}

Future<String?> _selectDevice() async {
  final devices = await listAvailableDevices();
  if (devices.isEmpty) return null;
  return await promptForDevice(devices);
}
