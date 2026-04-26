// test/create_command_test.dart

import 'package:test/test.dart';
import 'package:args/args.dart';

void main() {
  test('create command has required options', () {
    final parser = ArgParser()
      ..addFlag('help', abbr: 'h', negatable: false, help: 'Show usage')
      ..addCommand(
          'create',
          ArgParser()
            ..addOption('device', help: 'Device name (e.g. "pixel")')
            ..addOption('api', help: 'API level (e.g. 28)')
            ..addOption('abi',
                help:
                    'ABI for the system image (e.g. x86, x86_64, arm64-v8a)'));

    // Simulate running: `avd_manager create --device TestDevice --api android-33 --abi arm64-v8a`
    final results = parser.parse([
      'create',
      '--device',
      'TestDevice',
      '--api',
      'android-33',
      '--abi',
      'arm64-v8a'
    ]);

    final command = results.command;

    expect(command, isNotNull);
    expect(command!.name, equals('create'));
    expect(command['device'], equals('TestDevice'));
    expect(command['api'], equals('android-33'));
    expect(command['abi'], equals('arm64-v8a'));
  });
}
