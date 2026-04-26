import 'dart:io';
import 'package:args/args.dart';
import 'package:avd_manager/commands/create.dart';
import 'package:avd_manager/commands/delete.dart';
import 'package:avd_manager/commands/launch.dart' as launch_cmd;
import 'package:avd_manager/commands/list.dart';

void main(List<String> args) async {
  final createParser = ArgParser()
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show create usage')
    ..addOption('device', help: 'Device name (e.g. "pixel")')
    ..addOption('api', help: 'API level (e.g. 28)')
    ..addOption('abi',
        help: 'ABI for the system image (e.g. x86, x86_64, arm64-v8a)');

  final launchParser = ArgParser()
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show launch usage')
    ..addFlag('wipe-data', negatable: false, help: 'Wipe user data')
    ..addFlag('cold-boot', negatable: false, help: 'Cold boot the AVD')
    ..addFlag('no-snapshot-load',
        negatable: false, help: 'Do not load from snapshot')
    ..addFlag('no-snapshot-save',
        negatable: false, help: 'Do not save to snapshot on exit')
    ..addFlag('no-boot-anim', negatable: false, help: 'Disable boot animation');

  final deleteParser = ArgParser()
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show delete usage');

  final listParser = ArgParser()
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show list usage')
    ..addOption('sort',
        allowed: ['size', 'name'], help: 'Sort AVDs by "size" or "name"')
    ..addOption('min-size',
        help: 'Only show AVDs larger than this size (e.g. 500MB, 1GB)');

  final parser = ArgParser()
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show usage')
    ..addCommand('create', createParser)
    ..addCommand('launch', launchParser)
    ..addCommand('delete', deleteParser)
    ..addCommand('list', listParser);

  late ArgResults results;
  try {
    results = parser.parse(args);
  } catch (e) {
    print('❌ Error: ${e.toString()}');
    _printUsage(parser);
    exit(64); // Exit code 64 indicates a usage error
  }

  if (results['help'] as bool) {
    _printUsage(parser);
    return;
  }

  if (results.command == null) {
    _printUsage(parser);
    return;
  }

  switch (results.command!.name) {
    case 'launch':
      final cmd = results.command!;
      final name = cmd.rest.isNotEmpty ? cmd.rest[0] : null;
      final extraArgs = <String>[];
      List<String> emulatorArgs = [];

      if (cmd.wasParsed('wipe-data')) {
        emulatorArgs.add('-wipe-data');
      }

      if (cmd['cold-boot']) extraArgs.add('-no-snapshot-load');
      if (cmd['no-snapshot-load']) extraArgs.add('-no-snapshot-load');
      if (cmd['no-snapshot-save']) extraArgs.add('-no-snapshot-save');
      if (cmd['no-boot-anim']) extraArgs.add('-no-boot-anim');

      await launch_cmd.launchAvd(name, extraArgs: extraArgs);
      break;
    case 'create':
      final cmd = results.command!;
      if (cmd['help'] as bool) {
        print('Usage: avdm create <name> [options]\n${createParser.usage}');
        return;
      }
      final name = cmd.rest.isNotEmpty ? cmd.rest[0] : null;
      final device = cmd['device'] as String?;
      final api = cmd['api'] as String?;
      final abi = cmd['abi'] as String?;
      if (name == null || api == null) {
        print(
            '❌ AVD name and --api are required.\nUsage: avdm create <name> --device "Nexus 9" --api 30');
        return;
      }
      await createAvd(name, device: device, apiLevel: api, abi: abi);
      break;
    case 'delete':
      final cmd = results.command!;
      if (cmd['help'] as bool) {
        print('Usage: avdm delete <avd_name>');
        return;
      }
      final name = cmd.rest.isNotEmpty ? cmd.rest[0] : null;
      if (name == null) {
        print('❌ Please specify the AVD name to delete.');
        print('Usage: avdm delete <avd_name>');
        return;
      }
      await deleteAvd(name);
      break;
    case 'list':
      final cmd = results.command!;
      if (cmd['help'] as bool) {
        print('Usage: avdm list [options]\n${listParser.usage}');
        return;
      }
      final sortBy = cmd['sort'] ?? 'name';
      final minSizeStr = cmd['min-size'] ?? '0';
      await listAvds({
        'sort': sortBy,
        'min-size': minSizeStr,
      });
      break;
    default:
      print('❓ Unknown command: ${results.command!.name}');
      print('\n${usage(parser)}');
  }
}

void _printUsage(ArgParser parser) {
  print('''AVDM - Lightweight Android AVD Manager CLI
${usage(parser)}

Use "avdm <command> --help" for command-specific usage.
''');
}

// Function to generate usage string
String usage(ArgParser parser) =>
    'Usage: avdm <command> [options]\n\n${parser.usage}';
