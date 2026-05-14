import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:solulab_ocr_flutter/utils/app_colors.dart';
import 'package:solulab_ocr_flutter/utils/app_constant.dart';
import 'package:solulab_ocr_flutter/utils/app_design_constant.dart';

extension TextStyleE7n on TextStyle {
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
  TextStyle get extraBold => copyWith(fontWeight: FontWeight.w800);
}

extension WidgetExtension on Widget {
  Container defaultContainer({
    double hP = 16,
    double vP = 16,
    double vM = 0,
    BoxBorder? border,
    Color? backgroundColor,
    bool showShadow = true,
    double hM = 16,
    double borderRadius = cardBorderRadius,
    bool isGradientBg = false,
    bool isFullWidth = false,
  }) => Container(
    width: isFullWidth ? double.infinity : null,
    decoration: BoxDecoration(
      border: border,
      color: backgroundColor ?? secondaryColor,
      boxShadow: showShadow ? containerShadow : null,
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    padding: EdgeInsets.symmetric(horizontal: hP, vertical: vP),
    margin: EdgeInsets.symmetric(horizontal: hM, vertical: vM),
    child: this,
  );

  // Widget setGradient() => ShaderMask(
  //   blendMode: BlendMode.srcIn,
  //   shaderCallback:
  //       (bounds) => LinearGradient(
  //         colors: [gradient1, gradient2],
  //       ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
  //   child: this,
  // );

  Widget showShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade200,
      child: this,
    );
  }
}

extension BuildContextExtension on BuildContext {
  MediaQueryData get mq => MediaQuery.of(this);

  TextTheme get tt => Theme.of(this).textTheme;

  ColorScheme get cs => Theme.of(this).colorScheme;

  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;

  double get topPadding => math.max(statusBarHeight + 15, 15);

  double get bottomPadding => math.max(bottomSafeHeight + 15, 15);

  double get statusBarHeight => MediaQuery.of(this).viewPadding.top;

  double get bottomSafeHeight => MediaQuery.of(this).viewPadding.bottom;

  double get devicePixelRatio => MediaQuery.of(this).devicePixelRatio;
}

extension StringExtension on String {
  // void showSnackbar({required SnackbarType type, void Function(GetSnackBar)? onTap}) {
  //   final style = snackbarStyles[type]!;
  //   Get
  //     ..closeAllSnackbars()
  //     ..rawSnackbar(
  //       snackPosition: SnackPosition.TOP,
  //       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //       borderRadius: 16,
  //       backgroundColor: style.background,
  //       borderColor: style.border,
  //       padding: const EdgeInsets.all(12),
  //       duration: const Duration(seconds: 4),
  //       messageText: Row(
  //         children: [
  //           SvgPicture.asset(style.icon),
  //           const SizedBox(width: 12),
  //           Expanded(child: Text(this, style: TextStyle(fontSize: 14, color: style.text))),
  //         ],
  //       ),
  //     );
  String get maskedCardNumber {
    final cleaned = replaceAll(' ', '');
    if (cleaned.length < 4) return this;
    final last4 = cleaned.substring(cleaned.length - 4);
    final maskedLength = cleaned.length - 4;
    final masked = List.generate(maskedLength, (_) => 'X').join();
    final combined = masked + last4;
    final buffer = StringBuffer();
    for (int i = 0; i < combined.length; i++) {
      buffer.write(combined[i]);
      if ((i + 1) % 4 == 0 && i != combined.length - 1) {
        buffer.write(' ');
      }
    }
    return buffer.toString();
  }
}

  // void errorSnackbar() => showSnackbar(type: SnackbarType.error);
  // void warningSnackbar() => showSnackbar(type: SnackbarType.warning);
  // void successSnackbar() => showSnackbar(type: SnackbarType.success);
  // void infoSnackbar() => showSnackbar(type: SnackbarType.info);
