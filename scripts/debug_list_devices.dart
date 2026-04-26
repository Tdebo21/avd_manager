import 'package:avd_manager/avd_utils.dart';

Future<void> main() async {
  final result = await runAvdManager(['list', 'device']);
  print('exit=${result.exitCode}');
  print('stdout=<<${result.stdout}>>');
  print('stderr=<<${result.stderr}>>');
  final regex = RegExp(r'id: \d+ or "(.*?)"');
  for (final line in result.stdout.toString().split('\n')) {
    final match = regex.firstMatch(line);
    if (match != null) {
      print('MATCH: ${match.group(1)}');
    }
  }
}
