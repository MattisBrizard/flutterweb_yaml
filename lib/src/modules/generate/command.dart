import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:flutterweb_yaml/src/critical_exception.dart';
import 'package:flutterweb_yaml/src/log.dart' as log;
import 'package:flutterweb_yaml/src/provider.dart';
import 'package:flutterweb_yaml/src/utils.dart';
import 'package:mustache/mustache.dart' as mustache;
import 'package:resource/resource.dart';
import 'package:path/path.dart' as path;

class GenerateCommand extends Command {
  GenerateCommand() {
    argParser
      ..addOption(
        'provider',
        help: 'The name of the pipeline provider. (defaults to github)',
        allowed: <String>[
          'github',
        ],
        allowedHelp: <String, String>{
          'github': 'Github Actions to deploy on Github Pages.',
        },
        defaultsTo: 'github',
      )
      ..addOption(
        'path',
        help: 'The path of the app to build and deploy.',
        defaultsTo: '.',
      )
      ..addFlag(
        'package',
        negatable: false,
        defaultsTo: false,
        help:
            'Assume that the app to deploy is located in example folder (overrides --path option)',
      )
      ..addFlag(
        'overwrite',
        negatable: true,
        defaultsTo: true,
        help: 'When performing operations, overwrite existing file.',
      );
  }

  @override
  String get name => 'generate';

  @override
  String get description => 'Generate Flutter Web CI/CD yaml file.';

  @override
  String get invocation =>
      'flutterweb_yaml generate (--provider <provider name> --path <path to app>)';

  @override
  Future<void> run() {
    final String providerString = _getArg(
      'provider',
      argResults,
      isMandatory: true,
    );
    final Provider provider = Provider.values.firstWhere(
      (provider) => describeEnum(provider) == providerString,
      orElse: () => throw CriticalException(
        'The provider `$providerString` is not available.',
      ),
    );
    final String appPath = _getArg(
      'path',
      argResults,
      isMandatory: true,
    );
    final bool isPackage = _getArg(
      'package',
      argResults,
      isMandatory: true,
    );
    final bool overwrite = _getArg(
      'overwrite',
      argResults,
      isMandatory: true,
    );

    return _generate(
      provider,
      path.normalize(isPackage ? 'example' : appPath),
      overwrite,
    );
  }

  T _getArg<T>(String name, ArgResults argResults, {bool isMandatory = false}) {
    final T arg = argResults[name] as T;
    if (arg == null && isMandatory) {
      throw UsageException('The `$name` is mandatory', usage);
    }
    return arg;
  }
}

Future<void> _generate(
  Provider provider,
  String appPath,
  bool overwrite,
) async {
  log.startSection('Generating yaml file for ${describeEnum(provider)}.');
  final String templateContent = await Resource(
    _providerTemplatePath(provider),
  ).readAsString();

  final Map<String, dynamic> templateContext = <String, dynamic>{
    'path': appPath,
  };

  final String contents = mustache.Template(templateContent).renderString(
    templateContext,
  );

  File file = File(_providerYamlPath(provider));

  if (file.existsSync() && !overwrite) {
    log.endSection('File ${file.path} already exists.');
    return true;
  } else {
    file
      ..createSync(recursive: true)
      ..writeAsStringSync(contents);
    log.endSection('File ${file.path} created.');
  }
}

String _providerTemplatePath(Provider provider) {
  switch (provider) {
    case Provider.github:
      return '$_templatePath/github/build_deploy_web.yml.tmpl';
    default:
      throw CriticalException('The provider `$provider` is not available.');
  }
}

String _providerYamlPath(Provider provider) {
  switch (provider) {
    case Provider.github:
      return '.github/workflows/build_deploy_web.yml';
    default:
      throw CriticalException('The provider `$provider` is not available.');
  }
}

const String _templatePath = 'package:flutterweb_yaml/templates';
