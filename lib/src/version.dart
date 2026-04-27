import 'dart:io';
import 'package:yaml/yaml.dart';

String getVersion() {
  try {
    // Look for pubspec.yaml in the project root
    final pubspecPath = _findPubspecPath();

    if (pubspecPath != null && File(pubspecPath).existsSync()) {
      final pubspecContent = File(pubspecPath).readAsStringSync();
      final pubspec = loadYaml(pubspecContent) as Map;
      return pubspec['version'] ?? 'unknown';
    }
  } catch (e) {
    // Silently fail and return unknown
  }
  return 'unknown';
}

/// Find pubspec.yaml by walking up the directory tree
String? _findPubspecPath() {
  var current = Directory.current;

  while (true) {
    final pubspecFile = File('${current.path}/pubspec.yaml');
    if (pubspecFile.existsSync()) {
      return pubspecFile.path;
    }

    final parent = current.parent;
    if (parent.path == current.path) {
      // Reached filesystem root
      return null;
    }
    current = parent;
  }
}
