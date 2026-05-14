import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solulab_ocr_flutter/core/routes/app_pages.dart';
import 'package:solulab_ocr_flutter/designs/components/app_components_import.dart';
import 'package:solulab_ocr_flutter/designs/screens/images_view/image_view_controller.dart';
import 'package:solulab_ocr_flutter/utils/app_assets.dart';
import 'package:solulab_ocr_flutter/utils/app_colors.dart';
import 'package:solulab_ocr_flutter/utils/app_constant.dart';
import 'package:solulab_ocr_flutter/utils/app_design_constant.dart';
import 'package:solulab_ocr_flutter/utils/app_enums.dart';
import 'package:solulab_ocr_flutter/utils/app_extensions.dart';
import 'package:solulab_ocr_flutter/utils/app_textstyles.dart';

class ImageView extends StatelessWidget {
  const ImageView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageViewController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              controller.scanType == ScanType.card
                  ? 'Card View'
                  : 'Bank Passbook View',
            ),
            centerTitle: true,
          ),
          bottomNavigationBar: SafeArea(
            child: PrimaryButton(
              label: "Go to Home",
              onPress: () => Get.offAllNamed(Routes.HOME),
            ),
          ).paddingSymmetric(horizontal: 16, vertical: context.bottomPadding),
          body: controller.isAnalyzing
              ? Center(child: defaultLoader())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ImagePreviewCard(imagePath: controller.imageFile ?? ""),
                    SizedBox(height: 20),
                    controller.scanType == ScanType.card
                        ? (isNullEmptyOrFalse(
                                controller.cardDetails?.cardNumber,
                              )
                              ? const ErrorStateWidget(
                                  message: "No valid card detected",
                                  icon: AppIcons.card,
                                )
                              : const ShowCardDetails())
                        : (isNullEmptyOrFalse(
                                controller.bankDetails?.accountNumber,
                              )
                              ? const ErrorStateWidget(
                                  message: "No valid passbook detected",
                                  icon: AppIcons.passbook,
                                )
                              : const ShowPassbookDetail()),
                  ],
                ),
        );
      },
    );
  }
}

class ErrorStateWidget extends StatelessWidget {
  final String message;
  final String icon;

  const ErrorStateWidget({
    super.key,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(icon, height: 90, width: 90),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextThemeX().text16.copyWith(color: Colors.redAccent),
        ),
        const SizedBox(height: 8),
        Text(
          "Please ensure the image is clear, well-lit, and the document is fully visible within the frame.",
          textAlign: TextAlign.center,
          style: TextThemeX().text14.copyWith(color: whiteColor.withAlpha(140)),
        ),
      ],
    ).defaultContainer();
  }
}

class ShowCardDetails extends StatelessWidget {
  const ShowCardDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageViewController>(
      builder: (controller) {
        return Column(
          children: [
            AppKeyValueText(
              title: 'Number',
              value: controller.cardDetails?.cardNumber ?? na,
            ),
            AppKeyValueText(
              title: 'Expiry Date',
              value: controller.cardDetails?.expiryDate ?? na,
            ),
            AppKeyValueText(
              title: 'Card Holder',
              value: controller.cardDetails?.cardHolderName ?? na,
            ),
          ],
        ).defaultContainer();
      },
    );
  }
}

class ShowPassbookDetail extends StatelessWidget {
  const ShowPassbookDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageViewController>(
      builder: (controller) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppKeyValueText(
              title: 'Account Number',
              value: controller.bankDetails?.accountNumber ?? na,
            ),
            AppKeyValueText(
              title: 'IFSC Code',
              value: controller.bankDetails?.ifscCode ?? na,
            ),
            AppKeyValueText(
              title: 'Account Holder Name',
              value: controller.bankDetails?.accountHolderName ?? na,
            ),
          ],
        ).defaultContainer();
      },
    );
  }
}
