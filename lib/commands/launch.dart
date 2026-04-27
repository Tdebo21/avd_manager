import 'dart:io';
import 'package:process_run/shell.dart';

/// Lists available AVDs by reading ~/.android/avd directory
Future<List<String>> listAvds() async {
  final home = Platform.environment['HOME'] ?? '';
  final avdDir = Directory('$home/.android/avd');
  if (!await avdDir.exists()) return [];

  final avds = <String>[];

  await for (var entity in avdDir.list()) {
    if (entity is File && entity.path.endsWith('.ini')) {
      final name = entity.uri.pathSegments.last.replaceAll('.ini', '');
      avds.add(name);
    }
  }

  return avds;
}

/// Prompt the user to choose an AVD
Future<String?> promptAvdSelection(List<String> avds) async {
  print('\n📱 Available AVDs:\n');
  for (int i = 0; i < avds.length; i++) {
    print('  [${i + 1}] ${avds[i]}');
  }

  stdout.write('\nEnter AVD number to launch: ');
  final input = stdin.readLineSync();
  final index = int.tryParse(input ?? '');

  if (index != null && index > 0 && index <= avds.length) {
    return avds[index - 1];
  }

  print('❌ Invalid selection.');
  return null;
}

/// Launches the given AVD with optional flags
Future<void> launchAvd(String? name, {List<String>? extraArgs}) async {
  final shell = Shell();

  if (name == null) {
    final avds = await listAvds();
    if (avds.isEmpty) {
      print('❌ No AVDs found.');
      return;
    }
    name = await promptAvdSelection(avds);
    if (name == null) return;
  }

  print('🚀 Launching AVD "$name"...');

  final args = [
    '-avd',
    name,
    ...?extraArgs,
  ];

  try {
    await shell.run('emulator ${args.join(' ')}');
  } catch (e) {
    print('❌ Failed to launch AVD "$name": $e');
  }
}
