import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solulab_ocr_flutter/core/routes/app_pages.dart';
import 'package:solulab_ocr_flutter/utils/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes,
      initialRoute: Routes.HOME,
      initialBinding: BindingsX.initialBindings(),
      theme: AppTheme.appDarkTheme,
    );
  }
}
