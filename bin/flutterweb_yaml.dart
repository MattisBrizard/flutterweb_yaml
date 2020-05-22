import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:flutterweb_yaml/src/modules/generate/command.dart';
import 'package:flutterweb_yaml/src/modules/version/command.dart';
import 'package:flutterweb_yaml/src/log.dart' as log;
import 'package:flutterweb_yaml/src/critical_exception.dart';

void main(List<String> args) {
  final bool verbose = args.contains('v') || args.contains('--verbose');
  final runner = CommandRunner(
    'flutterweb_yaml',
    'CLI tool to generate Flutter Web CI/CD yaml file.',
  )
    ..addCommand(VersionCommand())
    ..addCommand(GenerateCommand())
    ..argParser.addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Noisy logging, including all shell commands executed.',
    );

  runner.run(args).catchError((error, stackTrace) {
    final StackTrace st = verbose ? stackTrace : null;
    if (error is UsageException) {
      log.error(error.message, stackTrace: st);
      exit(64);
    } else if (error is CriticalException) {
      log.error(error.message, stackTrace: st);
      exit(2);
    } else {
      throw error;
    }
  });
}
