import 'package:solulab_ocr_flutter/core/models/bank_details_model.dart';

class PassbookParser {
  PassbookParser._();
  factory PassbookParser() => _instance;
  static final _instance = PassbookParser._();

  // Bank-specific lengths derived from Core Banking Systems (CBS) [1, 2]
  static const Map<String, int> _bankAccountLengths = {
    'SBIN': 11, // State Bank of India
    'HDFC': 14, // HDFC Bank
    'ICIC': 12, // ICICI Bank
    'CNRB': 13, // Canara Bank
    'BARB': 14, // Bank of Baroda
    'PUNB': 16, // Punjab National Bank
  };

  // Indian State/UT list for filtering geographic noise [3, 4]
  static const _geoNoise ="";

  // Common Indian Surnames for Name Triangulation [5, 6]
  static const _commonSurnames =;

  static BankDetails parsePassbook(String rawText) {
    // 1. Character-Level Normalization [7, 8]
    final normalizedText = rawText.toUpperCase().replaceAll('O', '0').replaceAll('o', '0');
    final lines = rawText.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    final upperLines = lines.map((e) => e.toUpperCase()).toList();

    // 2. Structural Anchor: Extract IFSC first [9, 10]
    final ifsc = _extractIfsc(normalizedText);
    
    // 3. Contextual Extraction: Use IFSC metadata to find Account Number [8, 11]
    final bankPrefix = ifsc!= null? ifsc.substring(0, 4) : null;
    final accountNumber = _extractAccountNumber(lines, upperLines, bankPrefix);

    // 4. Semantic Parsing: Extract Name using relationship delimiters [12, 13]
    final name = _extractName(lines, upperLines);

    return BankDetails(
      accountHolderName: name,
      accountNumber: accountNumber,
      ifscCode: ifsc,
    );
  }

  // ====================== IFSC (The Anchor) ======================
  static String? _extractIfsc(String text) {
    // Strict RBI standard: 4 letters, 0, 6 alphanumeric [9, 13]
    final match = RegExp(r'\b[A-Z]{4}0[A-Z0-9]{6}\b').firstMatch(text);
    return match?.group(0);
  }

  // ====================== ACCOUNT NUMBER (Triangulated) ======================
  static String? _extractAccountNumber(List<String> lines, List<String> upperLines, String? bankPrefix) {
    final targetLength = _bankAccountLengths[bankPrefix];
    final digitRegex = RegExp(r'\b(\d{9,18})\b');
    
    // Proximity search: find labels first [14, 15]
    for (int i = 0; i < upperLines.length; i++) {
      if (upperLines[i].contains('ACCOUNT') || upperLines[i].contains('A/C') || upperLines[i].contains('AC NO')) {
        // Look in a narrow window (8 lines) to avoid CIF/Geographic noise [8, 16]
        for (int j = i; j < i + 8 && j < lines.length; j++) {
          final normalizedLine = lines[j].replaceAll('O', '0').replaceAll('o', '0');
          for (final match in digitRegex.allMatches(normalizedLine)) {
            final num = match.group(1)!;
            // If we know the bank, prioritize that exact length [1, 2]
            if (targetLength!= null && num.length == targetLength) return num;
            if (_isValidGenericAccount(num)) return num;
          }
        }
      }
    }
    return _fallbackLongestDigit(lines, digitRegex);
  }

  static bool _isValidGenericAccount(String num) {
    // Filter out 10-digit mobile numbers starting with 6-9 [17]
    if (num.length == 10 && RegExp(r'^[6-9]').hasMatch(num)) return false;
    return num.length >= 9 && num.length <= 18;
  }

  // ====================== NAME (Semantic) ======================
  static String? _extractName(List<String> lines, List<String> upperLines) {
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final upper = upperLines[i];

      // Priority 1: Clear "Name" label [18, 16]
      if (upper.contains('NAME') || upper.contains('HOLDER')) {
        String namePart = line.split(RegExp(r'[:\-]+')).last.trim();
        if (_isLikelyName(namePart)) return _cleanAndNormalize(namePart);
        
        // If label is on line i, name is often on i+1
        if (i + 1 < lines.length && _isLikelyName(lines[i+1])) {
          return _cleanAndNormalize(lines[i+1]);
        }
      }

      // Priority 2: Relationship markers (S/O, D/O, W/O) [12, 13]
      if (upper.contains('S/O') || upper.contains('D/O') || upper.contains('W/O')) {
        final parts = upper.split(RegExp(r'S/O|D/O|W/O'));
        if (parts.isNotEmpty && _isLikelyName(parts)) {
          return _cleanAndNormalize(lines[i].substring(0, lines[i].indexOf(RegExp(r'S/O|D/O|W/O', caseSensitive: false))).trim());
        }
      }
    }
    return null;
  }

  static bool _isLikelyName(String text) {
    final upper = text.toUpperCase();
    // Filter out geographic noise [3]
    if (_geoNoise.any((geo) => upper.contains(geo))) return false;
    // Check for titles or surnames [19, 6]
    if (RegExp(r'\b(MR|MRS|MS|SHRI|SMT)\b').hasMatch(upper)) return true;
    if (_commonSurnames.any((surname) => upper.contains(surname))) return true;
    return text.length > 5 &&!upper.contains('BANK');
  }

  static String _cleanAndNormalize(String raw) {
    return raw.trim()
       .replaceFirst(RegExp(r'^(MR|MRS|MS|SHRI|SMT|SH)\.?\s*', caseSensitive: false), '')
       .replaceAll(RegExp(r'[:\-0-9]'), '') // Remove noise characters
       .split(RegExp(r'\s+'))
       .where((w) => w.isNotEmpty)
       .map((w) => w.toUpperCase() + w.substring(1).toLowerCase())
       .join(' ');
  }

  static String? _fallbackLongestDigit(List<String> lines, RegExp digitRegex) {
    String? best;
    for (final line in lines) {
      final normalizedLine = line.replaceAll('O', '0').replaceAll('o', '0');
      for (final match in digitRegex.allMatches(normalizedLine)) {
        final num = match.group(1)!;
        if (_isValidGenericAccount(num) && (best == null || num.length > best.length)) {
          best = num;
        }
      }
    }
    return best;
  }
}