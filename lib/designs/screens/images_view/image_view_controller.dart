import 'dart:developer';

import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:solulab_ocr_flutter/core/models/bank_details_model.dart';
import 'package:solulab_ocr_flutter/core/models/card_details_model.dart';
import 'package:solulab_ocr_flutter/core/models/image_preview_screen_argument.dart';
import 'package:solulab_ocr_flutter/core/services/card_parcing_service.dart';
import 'package:solulab_ocr_flutter/core/services/ocr_service.dart';
import 'package:solulab_ocr_flutter/core/services/passbook_parcer_service.dart';
import 'package:solulab_ocr_flutter/utils/app_enums.dart';

class ImageViewController extends GetxController {
  String? imageFile;
  bool isAnalyzing = false;
  ScanType? scanType;
  CardDetails? cardDetails;
  BankDetails? bankDetails;
  final OCRService _ocrService = OCRService();
  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as ImagePreviewScreenArgument;
    imageFile = args.capturedImage;
    scanType = args.scanType;
    analyzeImage();
  }

  Future<void> analyzeImage() async {
    isAnalyzing = true;
    update();
    final inputImage = InputImage.fromFilePath(imageFile ?? "");
    final rawText = await _ocrService.processImage(inputImage);
    log("row text: $rawText");
    if (scanType == ScanType.card) {
      cardDetails = CardParser.parseCard(rawText);
    } else if (scanType == ScanType.passbook) {
      bankDetails = PassbookParser.parsePassbook(rawText);
      log("Bank Details: ${bankDetails.toString()}");
    }
    update();
    isAnalyzing = false;
    update();
  }

  @override
  void onClose() {
    _ocrService.dispose();
    super.onClose();
  }
}
