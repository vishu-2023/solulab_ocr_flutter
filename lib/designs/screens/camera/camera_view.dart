import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solulab_ocr_flutter/core/routes/app_pages.dart';
import 'package:solulab_ocr_flutter/designs/components/app_components_import.dart';
import 'package:solulab_ocr_flutter/designs/screens/camera/camera_view_controller.dart';
import 'package:solulab_ocr_flutter/utils/app_design_constant.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CameraViewController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Capture Image'),
            centerTitle: true,
            leading: AppBackButton(),
          ),
          body:
              (controller.cameraController == null ||
                  !controller.cameraController!.value.isInitialized)
              ? Center(child: defaultLoader())
              : CameraPreview(controller.cameraController!),

          bottomNavigationBar: const CameraCustomButtons(),
        );
      },
    );
  }
}

class CameraCustomButtons extends StatelessWidget {
  const CameraCustomButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CameraViewController>(
      builder: (controller) {
        return SafeArea(
          child: Row(
            children: [
              Expanded(
                child: PrimaryButton(label: 'Cancel', onPress: () {}),
              ),
              const SizedBox(width: 16),
              Obx(
                () => Expanded(
                  child: PrimaryButton(
                    label: "Capture Image",
                    onPress: () => controller.onCaptureButtonPressed(),
                    isLoading: controller.isImageCapturing.value,
                  ),
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 16, vertical: 16),
        );
      },
    );
  }
}
