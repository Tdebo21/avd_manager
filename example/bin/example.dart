import 'package:avd_manager/avd_utils.dart';
import 'package:avd_manager/commands/list.dart' hide getAvailableAvds;

Future<void> main() async {
  //list available AVDs with their sizes
  final avdData = await getAvailableAvds();
  if (avdData.isEmpty) {
    print('No AVDs found in the system.');
    return;
  }
  for (final avd in await getAvailableAvds()) {
    final sizeStr = formatSize(avd.sizeBytes);
    print('AVD: ${avd.name}, Size: ($sizeStr)');
  }
}
