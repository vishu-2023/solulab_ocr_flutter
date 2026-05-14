import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solulab_ocr_flutter/core/routes/app_pages.dart';
import 'package:solulab_ocr_flutter/designs/components/app_components_import.dart';
import 'package:solulab_ocr_flutter/designs/screens/images_view/image_view_controller.dart';
import 'package:solulab_ocr_flutter/utils/app_constant.dart';
import 'package:solulab_ocr_flutter/utils/app_design_constant.dart';
import 'package:solulab_ocr_flutter/utils/app_enums.dart';
import 'package:solulab_ocr_flutter/utils/app_extensions.dart';

class ImageView extends StatelessWidget {
  const ImageView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageViewController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: const Text('Image View'), centerTitle: true),
          bottomNavigationBar: CancelSubmitButtons(
            onSubmit: () => Get.offAllNamed(Routes.HOME),
            useSafeArea: true,
          ),
          body: controller.isAnalyzing
              ? Center(child: defaultLoader())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ImagePreviewCard(imagePath: controller.imageFile ?? ""),
                    SizedBox(height: 20),
                    controller.scanType == ScanType.card
                        ? const ShowCardDetails()
                        : const ShowPassbookDetail(),
                  ],
                ),
        );
      },
    );
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
            AppKeyValueText(title: 'Number', value: controller.cardDetails?.cardNumber ?? na),
            AppKeyValueText(title: 'Expiry Date', value: controller.cardDetails?.expiryDate ?? na),
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
            AppKeyValueText(title: 'IFSC Code', value: controller.bankDetails?.ifscCode ?? na),
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
