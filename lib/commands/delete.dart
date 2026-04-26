import 'dart:io';
import 'package:path/path.dart' as p;

Future<void> deleteAvd(String name) async {
  final avdHome = Platform.environment['ANDROID_AVD_HOME'] ??
      p.join(Platform.environment['HOME']!, '.android', 'avd');
  final iniPath = p.join(avdHome, '$name.ini');
  final avdPath = p.join(avdHome, '$name.avd');

  final iniFile = File(iniPath);
  final avdDir = Directory(avdPath);

  if (!await iniFile.exists() && !await avdDir.exists()) {
    print('❌ AVD "$name" does not exist.');
    return;
  }

  try {
    if (await iniFile.exists()) {
      await iniFile.delete();
      print('🗑️ Deleted $iniPath');
    }
    if (await avdDir.exists()) {
      await avdDir.delete(recursive: true);
      print('🗑️ Deleted $avdPath');
    }
    print('✅ AVD "$name" deleted successfully.');
  } catch (e) {
    print('❌ Failed to delete AVD "$name": $e');
  }
}
