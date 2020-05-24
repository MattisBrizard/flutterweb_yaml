import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:flutterweb_yaml/src/critical_exception.dart';
import 'package:flutterweb_yaml/src/log.dart' as log;
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

class VersionCommand extends Command {
  @override
  String get name => 'version';

  @override
  String get description => 'Print flutterweb_yaml version.';

  @override
  String get invocation => 'flutterweb_yaml version';

  @override
  void run() => version();
}

void version() {
  final pubspecPath = path.join(
    path.dirname(path.dirname(Platform.script.path)),
    'pubspec.lock',
  );
  final pubspecFile = File(pubspecPath);
  if (!pubspecFile.existsSync()) {
    throw CriticalException(
      'The pubspec.lock file does not exist in this package',
    );
  }
  final pubspec = loadYaml(pubspecFile.readAsStringSync());
  final version = pubspec['packages']['flutterweb_yaml']['version'].toString();
  log.message('flutterweb_yaml $version');
}
