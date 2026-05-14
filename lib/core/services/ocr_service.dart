import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OCRService {
  OCRService._();
  factory OCRService() => _instance;
  static final OCRService _instance = OCRService._();

  final TextRecognizer _recognizer = TextRecognizer();
  Future<String> processImage(InputImage image) async {
    final result = await _recognizer.processImage(image);
    return result.text;
  }

  void dispose() {
    _recognizer.close();
  }
}
