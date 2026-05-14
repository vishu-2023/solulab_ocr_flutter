import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:solulab_ocr_flutter/core/models/image_preview_screen_argument.dart';
import 'package:solulab_ocr_flutter/core/routes/app_pages.dart';
import 'package:solulab_ocr_flutter/core/services/base_service.dart';
import 'package:solulab_ocr_flutter/utils/app_enums.dart';

class CameraViewController extends GetxController {
  CameraController? cameraController;
  RxBool isImageCapturing = false.obs;
  XFile? capturedImage;
  @override
  void onInit() {
    super.onInit();
    initCamera();
  }

  Future<void> initCamera() async {
    await tryOrCatch(() async {
      final cameras = await availableCameras();
      cameraController = CameraController(
        cameras.first,
        ResolutionPreset.max,
        enableAudio: false,
      );
      await cameraController!.initialize();
      update();
    });
  }

  Future<void> onCaptureButtonPressed() async {
    await tryOrCatch(() async {
      isImageCapturing.value = true;
      capturedImage = await cameraController?.takePicture();
      update();
      isImageCapturing.value = false;
    });
  }

  void onRetake() {
    capturedImage = null;
    update();
  }

  void onConfirm() {
    Get.offNamed(
      Routes.IMAGE_VIEW,
      arguments: ImagePreviewScreenArgument(
        capturedImage: capturedImage?.path,
        scanType: Get.arguments as ScanType,
      ),
    );
  }

  @override
  void onClose() {
    super.onClose();
    cameraController?.dispose();
  }
}
