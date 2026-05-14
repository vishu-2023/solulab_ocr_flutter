import 'package:flutter/material.dart';

Future<T> tryOrCatch<T>(Future<T> Function() methodToRun) async {
  try {
    return await methodToRun();
  } on AppException {
    rethrow;
  } catch (e, trace) {
    debugPrint("$e\n$trace");
    throw AppException("Internal Error", "Default Exception: ");
  }
}

class AppException implements Exception {
  final String? message;
  final String? prefix;

  AppException([this.message, this.prefix]);

  @override
  String toString() {
    return "$prefix $message";
  }
}
