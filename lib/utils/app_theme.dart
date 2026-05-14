import 'package:flutter/material.dart';
import 'package:solulab_ocr_flutter/utils/app_colors.dart';
import 'package:solulab_ocr_flutter/utils/app_textstyles.dart';

class AppTheme {
  AppTheme._();
  static ThemeData get appLightTheme => ThemeData(
    scaffoldBackgroundColor: Colors.white,
    // colorScheme: ColorScheme(
    //   brightness: Brightness.light,
    //   primary: Colors.black,
    //   onPrimary: Colors.white,
    //   secondary: Color(0xff323232),
    //   onSecondary: Colors.white,
    //   error: Color(0xffBC3C20),
    //   onError: Color(0xff20BCA4),
    //   surface: Colors.white,
    //   onSurface: Color(0xff7B849B),
    // ),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Color(0xff222222)),
  );
  static ThemeData get appDarkTheme => ThemeData(
    scaffoldBackgroundColor: Colors.black,
    // colorScheme: ColorScheme(
    //   brightness: Brightness.dark,
    //   primary: Colors.white,
    //   onPrimary: Colors.black,
    //   secondary: Color(0xff323232),
    //   onSecondary: Colors.white,
    //   error: Color(0xffBC3C20),
    //   onError: Color(0xff20BCA4),
    //   surface: Colors.black,
    //   onSurface: Color(0xff7B849B),
    // ),
    appBarTheme: AppBarTheme(
      backgroundColor: blackColor,
      elevation: 10,
      titleTextStyle: TextThemeX().text18.copyWith(color: Colors.white),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Color(0xff222222),
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(16)),
    ),
  );
  static const purpleColor = Color(0xff804FB0);
}
