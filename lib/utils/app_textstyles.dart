import 'package:flutter/material.dart';
import 'package:solulab_ocr_flutter/utils/app_constant.dart';
import 'package:solulab_ocr_flutter/utils/app_extensions.dart';

class TextThemeX {
  TextThemeX._();
  factory TextThemeX() => _instance;
  static final TextThemeX _instance = TextThemeX._();

  TextStyle get text15 => TextStyle(
    fontSize: 15,
    letterSpacing: -.24,
    color: Colors.black,
    fontFamily: fontFamily,
  ).medium;
  TextStyle get text14 => TextStyle(
    fontSize: 14,
    letterSpacing: -.24,
    color: Colors.black,
    fontFamily: fontFamily,
  ).medium;

  TextStyle get text16 => TextStyle(
    fontSize: 16,
    letterSpacing: -.24,
    color: Colors.black,
    fontFamily: fontFamily,
  ).medium;

  TextStyle get text18 => TextStyle(
    fontSize: 18,
    letterSpacing: -.24,
    color: Colors.black,
    fontFamily: fontFamily,
  ).medium;

  TextStyle get text24 => TextStyle(
    fontSize: 24,
    letterSpacing: -.24,
    color: Colors.black,
    fontFamily: fontFamily,
  ).medium;
  TextStyle get text22 => TextStyle(
    fontSize: 22,
    letterSpacing: -.24,
    color: Colors.black,
    fontFamily: fontFamily,
  ).medium;

  TextStyle get textFieldHeaderStyle => TextThemeX().text15.copyWith(fontSize: 12).semiBold;
}
