import 'package:test/test.dart';
import 'package:avd_manager/avd_utils.dart';

void main() {
  group('arg parser', () {
    test('parses list args correctly', () {
      final args = parseArguments(['list', '--sort', 'size']);
      expect(args['sort'], equals('size'));
      expect(args['min-size'], equals('0'));
      expect(args.containsKey('command'), isFalse);
      expect(args['name'], isNull);
      expect(args['min-size'], isNotNull);
      expect(args['list'], isNull);
    });

    test('returns null on empty args, and correct values on populated args',
        () {
      final args = parseArguments([]);
      expect(args, isA<Map<String, String>>());
      expect(args.length, equals(2));
      expect(args.containsKey('sort'), isTrue);
      expect(args.containsKey('min-size'), isTrue);
      expect(args['sort'], equals('name'));
      expect(args['min-size'], equals('0'));
      expect(args['command'], isNull);
    });
  });

// Function to format size in bytes to a human-readable string
  // ignore: no_leading_underscores_for_local_identifiers
  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    final kb = bytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
    final mb = kb / 1024;
    if (mb < 1024) return '${mb.toStringAsFixed(1)} MB';
    final gb = mb / 1024;
    return '${gb.toStringAsFixed(1)} GB';
  }

  group('formatSize', () {
    test('formats bytes correctly', () {
      expect(_formatSize(500), equals('500 B'));
      expect(_formatSize(1024), equals('1.0 KB'));
      expect(_formatSize(1536), equals('1.5 KB'));
      expect(_formatSize(1048576), equals('1.0 MB'));
      expect(_formatSize(1572864), equals('1.5 MB'));
      expect(_formatSize(1073741824), equals('1.0 GB'));
      expect(_formatSize(1610612736), equals('1.5 GB'));
    });
  });
}
