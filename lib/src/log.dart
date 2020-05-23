import 'dart:io';

void message(String message) {
  stdout.writeln('$message');
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
