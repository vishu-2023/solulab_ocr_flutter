import 'package:flutter/material.dart';
import 'package:solulab_ocr_flutter/utils/app_colors.dart';

List<BoxShadow> get containerShadow {
  return [
    BoxShadow(blurRadius: 10, offset: const Offset(0, 4), color: Colors.white.withOpacity(.06)),
  ];
}

bool isNullEmptyOrFalse(dynamic o) {
  if (o is Map<String, dynamic> || o is List<dynamic>) {
    return o == null || o.length == 0;
  }
  return o == null || o == false || o == "";
}

Widget defaultLoader() {
  return Builder(
    builder: (context) => CircularProgressIndicator(strokeWidth: 2, color: primaryColor),
  );
}
