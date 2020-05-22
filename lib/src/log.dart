import 'dart:io';

int _indent = 0;

void startSection(String msg) => message(msg, ++_indent);

void inSection(String msg) => message(msg, _indent * 2);

void endSection(String msg) => message(msg, _indent--);

void message(String message, [int indent = 0]) {
  final left = ''.padLeft(indent);
  stdout.writeln('$left$message');
}

void error(
  String message, {
  StackTrace stackTrace,
}) {
  stderr.writeln(message);
  if (stackTrace != null) {
    stderr.writeln(stackTrace.toString());
  }
}
