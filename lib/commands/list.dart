import 'dart:io';
import 'package:avd_manager/avd_utils.dart';
import 'package:path/path.dart' as p;

// parse size strings like "500MB" into bytes
int parseSize(String input) {
  if (input.isEmpty) {
    throw FormatException('Size cannot be empty');
  }
  final pattern = RegExp(r'^(\d+(?:\.\d+)?)([KMG]B)$', caseSensitive: false);
  final match = pattern.firstMatch(input.trim());

  if (match == null) {
    throw FormatException(
        'Invalid size format: $input. Use formats like 500MB or 1GB');
  }

  final value = double.parse(match.group(1)!); // The numeric part
  if (value <= 0) {
    throw FormatException('Size must be greater than 0');
  }
  final unit = match.group(2)!.toUpperCase(); // The unit (MB, GB, etc.)

  switch (unit) {
    case 'KB':
      return (value * 1024).toInt();
    case 'MB':
      return (value * 1024 * 1024).toInt(); // Convert MB to bytes
    case 'GB':
      return (value * 1024 * 1024 * 1024).toInt(); // Convert GB to bytes
    default:
      throw FormatException('Unknown size unit: $unit');
  }
}

/// Format size strings like "500MB" into bytes
String formatSize(int bytes) {
  if (bytes >= 1 << 30) return '${(bytes / (1 << 30)).toStringAsFixed(2)} GB';
  if (bytes >= 1 << 20) return '${(bytes / (1 << 20)).toStringAsFixed(2)} MB';
  if (bytes >= 1 << 10) return '${(bytes / (1 << 10)).toStringAsFixed(2)} KB';
  return '$bytes B';
}

// Define a simple class to hold AVD data
class Avd {
  final String name;
  final int size;
  final String sizeStr;

  Avd(this.name, this.size, this.sizeStr);
}

/// ## ✅ Helper: `_getDirectorySize()
Future<int> _getDirectorySize(Directory directory) async {
  int totalSize = 0;
  if (await directory.exists()) {
    await for (final fileSystemEntity in directory.list(recursive: true)) {
      if (fileSystemEntity is File) {
        totalSize += await fileSystemEntity.length();
      }
    }
  }
  return totalSize;
}

String _formatSize(int bytes) {
  const units = ['B', 'KB', 'MB', 'GB'];
  double size = bytes.toDouble();
  int unit = 0;

  while (size > 1024 && unit < units.length - 1) {
    size /= 1024;
    unit++;
  }

  return '${size.toStringAsFixed(2)} ${units[unit]}';
}

/// ## ✅ Main Listing Function

Future<void> listAvds(Map<String, String> cmd) async {
  // Get AVD home directory
  final avdHome = Platform.environment['ANDROID_AVD_HOME'] ??
      p.join(Platform.environment['HOME']!, '.android', 'avd');

  final avdDir = Directory(avdHome);

  if (!await avdDir.exists()) {
    print('❌ AVD directory not found at $avdHome');
    return;
  }

  // List all AVD directories
  final avdDirectories = avdDir.listSync().whereType<Directory>();
  final avdData = <Avd>[];

  // Fetch size for each AVD asynchronously and build Avd objects
  for (final avd in avdDirectories) {
    final name = p.basenameWithoutExtension(avd.path);
    final size = await _getDirectorySize(avd);
    final sizeStr = _formatSize(size);
    avdData.add(Avd(name, size, sizeStr));
  }

  // Minimum AVDs check
  if (avdData.isEmpty) {
    print('No AVDs found.');
    return;
  }

  // Extract command-line arguments
  final sortBy = cmd['sort'] ?? 'name';
  final minSizeStr = cmd['min-size'] ?? '0';

  // Skip size filtering if 'min-size' is '0'
  if (minSizeStr != '0' && minSizeStr.isNotEmpty) {
    try {
      final minBytes = parseSize(minSizeStr);
      avdData.removeWhere((avd) => avd.size < minBytes);
    } catch (e) {
      print(
          '❌ Invalid size format: $minSizeStr. Use formats like 500MB or 1GB.');
      return;
    }
  }

  // Sort AVDs if 'sort' argument is provided
  if (sortBy == 'size') {
    avdData.sort((a, b) => a.size.compareTo(b.size));
  } else if (sortBy == 'name') {
    avdData.sort((a, b) => a.name.compareTo(b.name));
  }

  // Loop and print the sorted AVD data
  for (final avd in avdData) {
    print('• ${avd.name} (AVD directory size: ${avd.sizeStr})');
  }
}

/// ## ✅ Helper: `getAvailableAvds()
Future<List<AvdInfo>> getAvailableAvds() async {
  final avdHome = Platform.environment['ANDROID_AVD_HOME'] ??
      p.join(Platform.environment['HOME']!, '.android', 'avd');
  final avdDirectory = Directory(avdHome);
  if (!await avdDirectory.exists()) {
    print('❌ AVD directory does not exist at $avdHome');
    return [];
  }
  final avdDirs = await avdDirectory
      .list()
      .where((entity) => entity is Directory && entity.path.endsWith('.avd'))
      .toList();
  List<AvdInfo> avds = [];
  for (final entity in avdDirs) {
    final dir = entity as Directory;
    final size = await _getDirectorySize(dir);
    final name = p.basenameWithoutExtension(dir.path);
    avds.add(AvdInfo(name: name, sizeBytes: size));
  }
  return avds;
}
