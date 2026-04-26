import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:args/args.dart';

class AvdInfo {
  final String name;
  final int sizeBytes;

  AvdInfo({required this.name, required this.sizeBytes});
}

// Function to parse the command-line arguments and return a Map
Map<String, String> parseArguments(List<String> arguments) {
  final parser = ArgParser();
  parser.addOption('sort', defaultsTo: 'name');
  parser.addOption('min-size', defaultsTo: '0');

  final argResults = parser.parse(arguments);

  return {
    'sort': argResults['sort'] ?? 'name',
    'min-size': argResults['min-size'] ?? '0',
  };
}

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

Future<int> _getDirectorySize(Directory dir) async {
  int size = 0;
  await for (var entity in dir.list(recursive: true)) {
    if (entity is File) {
      size += await entity.length();
    }
  }
  return size;
}

Future<ProcessResult> runAvdManager(List<String> args) async {
  final javaHomeExpr = Platform.isMacOS ? r'$(echo $JAVA_HOME)' : r'$JAVA_HOME';
  final fullCommand =
      'export JAVA_HOME=$javaHomeExpr && avdmanager ${args.map((a) => '"$a"').join(' ')}';
  return await Process.run(
    'bash',
    ['-lc', fullCommand],
  );
}

Future<ProcessResult> runSdkManager(List<String> args) async {
  final environment = Map<String, String>.from(Platform.environment);
  final javaHome = Platform.environment['JAVA_HOME'];
  if (javaHome != null) {
    environment['JAVA_HOME'] = javaHome;
  }

  final process = await Process.start(
    'sdkmanager',
    ['--install', ...args],
    environment: environment,
    runInShell: false,
  );

  // Pre-answer any prompt with yes so sdkmanager can proceed.
  for (var i = 0; i < 20; i++) {
    process.stdin.writeln('y');
  }
  await process.stdin.close();

  final stdoutBuffer = StringBuffer();
  final stderrBuffer = StringBuffer();

  final stdoutDone = process.stdout.transform(utf8.decoder).forEach((chunk) {
    stdoutBuffer.write(chunk);
    stdout.write(chunk);
  });

  final stderrDone = process.stderr.transform(utf8.decoder).forEach((chunk) {
    stderrBuffer.write(chunk);
    stderr.write(chunk);
  });

  final exitCode = await process.exitCode.timeout(
    const Duration(minutes: 30),
    onTimeout: () {
      process.kill(ProcessSignal.sigkill);
      return -1;
    },
  );

  await Future.wait([stdoutDone, stderrDone]);

  return ProcessResult(
    process.pid,
    exitCode,
    stdoutBuffer.toString(),
    stderrBuffer.toString(),
  );
}

Future<void> createAndPatchAvd(String name,
    {required String device, required String systemImage}) async {
  print('📦 Ensuring system image is installed...');
  final sdkResult = await runSdkManager([systemImage]);
  if (sdkResult.exitCode == -1) {
    print('❌ System image installation timed out after 30 minutes.');
    print('Attempted system image package: $systemImage');
    print('This can happen when the image is large or your network is slow.');
    print('Please verify that sdkmanager is available and retry.');
    print('stdout:\n${sdkResult.stdout}');
    print('stderr:\n${sdkResult.stderr}');
    return;
  }

  if (sdkResult.exitCode != 0) {
    print('❌ Failed to install system image: $systemImage');
    print('stdout:\n${sdkResult.stdout}');
    print('stderr:\n${sdkResult.stderr}');
    return;
  }

  print('🧰 Creating AVD...');
  final javaHomeExpr = Platform.isMacOS ? r'$(echo $JAVA_HOME)' : r'$JAVA_HOME';

  final command = '''
    export JAVA_HOME=$javaHomeExpr;
    echo no | avdmanager create avd -n "$name" -k "$systemImage" --device "$device"
  ''';

  final result = await Process.run(
    'bash',
    ['-c', command],
    runInShell: true,
  );

  if (result.exitCode != 0) {
    print('❌ Failed to create AVD:\n${result.stdout}\n${result.stderr}');
    return;
  }

  print('✅ AVD $name created successfully.');

  // Confirm AVD actually exists
  final avdHome = Platform.environment['ANDROID_AVD_HOME'] ??
      '${Platform.environment['HOME']}/.android/avd';
  final configPath = '$avdHome/$name.avd/config.ini';
  final configFile = File(configPath);

  if (!configFile.existsSync()) {
    print('❌ Could not find config.ini for $name.');
    return;
  }

  print('🔧 Patching config.ini for performance...');
  var config = configFile.readAsStringSync();
  if (!config.contains('hw.gpu.enabled')) {
    config += '\nhw.gpu.enabled=yes\nhw.gpu.mode=auto\n';
    configFile.writeAsStringSync(config);
    print('✅ Patched config.ini for GPU acceleration.');
  } else {
    print('config.ini already patched.');
  }
}
