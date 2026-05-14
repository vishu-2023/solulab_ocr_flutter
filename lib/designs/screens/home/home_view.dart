import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:solulab_ocr_flutter/core/routes/app_pages.dart';
import 'package:solulab_ocr_flutter/designs/screens/home/home_view_controller.dart';
import 'package:solulab_ocr_flutter/utils/app_assets.dart';
import 'package:solulab_ocr_flutter/utils/app_colors.dart';
import 'package:solulab_ocr_flutter/utils/app_enums.dart';
import 'package:solulab_ocr_flutter/utils/app_extensions.dart';
import 'package:solulab_ocr_flutter/utils/app_textstyles.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeViewController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: const Text('Solulab OCR Scanner')),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Scan Document', style: TextThemeX().text18),
              SizedBox(height: 4),
              Text(
                'Choose document type to extract data',
                style: TextThemeX().text14.copyWith(color: whiteColor.withAlpha(140)),
              ),
              SizedBox(height: 20),
              _DocumentTypeCard(
                icon: AppIcons.passbook,
                title: 'Bank Passbook',
                subtitle: 'Extract account details',
                onTap: () => Get.toNamed(Routes.CAMERA, arguments: ScanType.passbook),
              ),
              SizedBox(height: 12),
              _DocumentTypeCard(
                icon: AppIcons.card,
                title: 'Debit Card',
                subtitle: 'Scan card details',
                onTap: () => Get.toNamed(Routes.CAMERA, arguments: ScanType.card),
              ),
              SizedBox(height: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.lightbulb_outline, color: primaryColor, size: 20),
                      SizedBox(width: 12),
                      Text('Quick Tips', style: TextThemeX().text16),
                    ],
                  ),
                  SizedBox(height: 12),
                  _TipItem('Ensure good lighting for better scanning'),
                  SizedBox(height: 8),
                  _TipItem('Place document flat on surface'),
                  SizedBox(height: 8),
                  _TipItem('Avoid shadows and glare'),
                ],
              ).defaultContainer(showShadow: false),
            ],
          ).paddingSymmetric(horizontal: 16),
        );
      },
    );
  }
}

class _DocumentTypeCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DocumentTypeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Image.asset(icon, width: 88, height: 88),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextThemeX().text18),
                SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextThemeX().text14.copyWith(color: whiteColor.withAlpha(140)),
                ),
              ],
            ),
          ),
          Transform.flip(flipX: true, child: SvgPicture.asset(AppIcons.arrowBack)),
        ],
      ).defaultContainer(showShadow: false),
    );
  }
}

class _TipItem extends StatelessWidget {
  final String text;

  const _TipItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: EdgeInsets.only(top: 6, right: 12),
          decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
        ),
        Expanded(
          child: Text(text, style: TextThemeX().text14.copyWith(color: whiteColor.withAlpha(140))),
        ),
      ],
    );
  }
}
