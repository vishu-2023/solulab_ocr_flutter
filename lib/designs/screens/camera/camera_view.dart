import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solulab_ocr_flutter/designs/components/app_components_import.dart';
import 'package:solulab_ocr_flutter/designs/screens/camera/camera_view_controller.dart';
import 'package:solulab_ocr_flutter/utils/app_colors.dart';
import 'package:solulab_ocr_flutter/utils/app_design_constant.dart';
import 'package:solulab_ocr_flutter/utils/app_extensions.dart';
import 'package:solulab_ocr_flutter/utils/app_textstyles.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CameraViewController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.black,
          body:
              (controller.cameraController == null ||
                  !controller.cameraController!.value.isInitialized)
              ? Center(child: defaultLoader())
              : Stack(
                  children: [
                    SizedBox.expand(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: controller
                              .cameraController!
                              .value
                              .previewSize!
                              .height,
                          height: controller
                              .cameraController!
                              .value
                              .previewSize!
                              .width,
                          child: CameraPreview(controller.cameraController!),
                        ),
                      ),
                    ),

                    /// APP BAR
                    const AppBar(),

                    /// BOTTOM CAPTURE BUTTON
                    if (isNullEmptyOrFalse(controller.capturedImage))
                      const CaptureButton(),

                    /// IMAGE CONFIRM CARD
                    if (!isNullEmptyOrFalse(controller.capturedImage))
                      ImagePreviewWidget(controller: controller),
                  ],
                ),
        );
      },
    );
  }
}

class CaptureButton extends StatelessWidget {
  const CaptureButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CameraViewController>(
      builder: (controller) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Obx(
                () => GestureDetector(
                  onTap: controller.isImageCapturing.value
                      ? null
                      : () => controller.onCaptureButtonPressed(),
                  child: Container(
                    width: 82,
                    height: 82,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xff3FA9FF), Color(0xffD94FD5)],
                        ),
                      ),
                      child: controller.isImageCapturing.value
                          ? const Padding(
                              padding: EdgeInsets.all(22),
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.blur_on,
                              color: Colors.white,
                              size: 34,
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ImagePreviewWidget extends StatelessWidget {
  const ImagePreviewWidget({super.key, required this.controller});
  final CameraViewController controller;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImagePreviewCard(imagePath: controller.capturedImage?.path ?? ""),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: controller.onRetake,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: secondaryColor.withAlpha(110),
                  ),
                  child: const Center(
                    child: Icon(Icons.delete, size: 24, color: whiteColor),
                  ),
                ),
              ),
              SizedBox(width: 24),
              InkWell(
                onTap: controller.onConfirm,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: secondaryColor.withAlpha(110),
                  ),
                  child: Center(
                    child: Icon(Icons.check, color: whiteColor, size: 24),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AppBar extends StatelessWidget {
  const AppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppBackButton(),
            SizedBox(width: 24),
            ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  colors: [Color(0xff3FA9FF), Color(0xffD94FD5)],
                ).createShader(bounds);
              },
              child: Text("Capture Image", style: TextThemeX().text22.semiBold),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
