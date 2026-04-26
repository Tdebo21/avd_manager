// test/list_avds_test.dart

import 'package:test/test.dart';
import 'package:args/command_runner.dart';
import 'package:avd_manager/commands/list.dart';
import 'dart:async';


class ListCommand extends Command {
  @override
  final name = 'list';
  @override
  final description = 'Lists available AVDs.';

  @override
  void run() {
    print('Listing all AVDs...');
    // Simulate list output
    print(' - pixel (API 33)');
    print(' - nexus (API 30)');
  }
}

void main() {
  group('ListCommand', () {
    test('prints list of AVDs', () async {
      final runner = CommandRunner('avd_manager', 'Test CLI')
        ..addCommand(ListCommand());

      final printLogs = <String>[];
      final specPrint = ZoneSpecification(
        print: (self, parent, zone, line) {
          printLogs.add(line);
        },
      );

      await Zone.current.fork(specification: specPrint).run(() async {
        await runner.run(['list']);
      });

      expect(printLogs, contains('Listing all AVDs...'));
      expect(printLogs.any((line) => line.contains('pixel')), isTrue);
    });
  });

  group('parseSize', () {
    test('parses GB correctly', () {
      expect(parseSize('2GB'), equals(2 * 1024 * 1024 * 1024));
    });

    test('parses MB correctly', () {
      expect(parseSize('512MB'), equals(512 * 1024 * 1024));
    });

    test('throws on invalid input', () {
      expect(() => parseSize('0'), throwsA(isA<FormatException>()));
      expect(() => parseSize('-100MB'), throwsA(isA<FormatException>()));
    });
    
    test('throws on invalid unit', () {
      expect(() => parseSize('100Z'), throwsA(isA<FormatException>()));
    });

    test('throws on empty string', () {
      expect(() => parseSize(''), throwsA(isA<FormatException>()));
    });
    
  });
  group('formatSize', () {
    test('formats size in GB', () {
      expect(formatSize(3 * 1024 * 1024 * 1024), contains('3.00 GB'));
    });

    test('formats size in MB', () {
      expect(formatSize(700 * 1024 * 1024), contains('700.00 MB'));
    });
  });
}

