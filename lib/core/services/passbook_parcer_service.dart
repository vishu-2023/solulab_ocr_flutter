import 'package:solulab_ocr_flutter/core/models/bank_details_model.dart';

class PassbookParser {
  PassbookParser._();
  factory PassbookParser() => _instance;
  static final _instance = PassbookParser._();

  // Bank-specific lengths derived from Core Banking Systems (CBS)
  static const Map<String, int> _bankAccountLengths = {
    'SBIN': 11, // State Bank of India
    'HDFC': 14, // HDFC Bank
    'ICIC': 12, // ICICI Bank
    'CNRB': 13, // Canara Bank
    'BARB': 14, // Bank of Baroda
    'PUNB': 16, // Punjab National Bank
    'UTIB': 15, // Axis Bank
    // IDIB (Indian Bank) is 9-18 digits, so we rely on general fallback.
  };

  // Indian State/UT list for filtering geographic noise
  static const List<String> _geoNoise = [
    'ANDHRA PRADESH',
    'BIHAR',
    'GUJARAT',
    'KARNATAKA',
    'MAHARASHTRA',
    'PUNJAB',
    'TAMIL NADU',
    'UTTAR PRADESH',
    'WEST BENGAL',
    'AHMEDABAD',
    'GHODASAR',
    'PIN',
    'PINCODE',
    'STATE',
    'BRANCH',
    'PASSBOOK',
    'AMARAVATI',
    'PATNA',
    'GANDHINAGAR',
    'BENGALURU',
    'MUMBAI',
    'CHANDIGARH',
    'CHENNAI',
    'LUCKNOW',
    'KOLKATA',
  ];

  // Common Indian Surnames for Name Triangulation
  static const List<String> _commonSurnames = [
    'PATEL',
    'SHAH',
    'DESAI',
    'MEHTA',
    'ADANI',
    'BANERJEE',
    'CHATTERJEE',
    'MUKHERJEE',
    'GHOSH',
    'BOSE',
    'SINGH',
    'KAUR',
    'MALHOTRA',
    'KHANNA',
    'ARORA',
    'KULKARNI',
    'DESHPANDE',
    'PATIL',
    'JOSHI',
    'GUPTE',
    'PILLAI',
    'REDDY',
    'NAIDU',
    'MANI',
    'IYER',
  ];

  static BankDetails parsePassbook(String rawText) {
    // 1. Character-Level Normalization
    final normalizedText = rawText.toUpperCase().replaceAll('o', '0');
    final lines = rawText
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final upperLines = lines.map((e) => e.toUpperCase()).toList();

    // 2. Structural Anchor: Extract IFSC first
    final ifsc = _extractIfsc(normalizedText);

    // 3. Contextual Extraction: Use IFSC metadata to find Account Number
    final bankPrefix = ifsc != null ? ifsc.substring(0, 4) : null;
    final accountNumber = _extractAccountNumber(lines, upperLines, bankPrefix);

    // 4. Semantic Parsing: Extract Name using relationship delimiters
    final name = _extractName(lines, upperLines);

    return BankDetails(
      accountHolderName: name,
      accountNumber: accountNumber,
      ifscCode: ifsc,
    );
  }

  // ====================== IFSC (The Anchor) ======================
  static String? _extractIfsc(String text) {
    // Strict RBI standard: 4 letters, 0 (or misread O), 6 alphanumeric
    // We allow 'O' in the 5th place and force it to '0' during extraction
    final match = RegExp(r'\b[A-Z]{4}[0O][A-Z0-9]{6}\b').firstMatch(text);
    if (match != null) {
      String extracted = match.group(0)!;
      // Force 5th character to '0' and replace remaining 'O's with '0's (branch codes are numeric)
      String rest = extracted.substring(5).replaceAll('O', '0');
      return extracted.substring(0, 4) + '0' + rest;
    }
    return null;
  }

  // ====================== ACCOUNT NUMBER (Triangulated) ======================
  static String? _extractAccountNumber(
    List<String> lines,
    List<String> upperLines,
    String? bankPrefix,
  ) {
    final targetLength = _bankAccountLengths[bankPrefix];
    final digitRegex = RegExp(r'\b(\d{9,18})\b');

    Set<String> proximityPool = {};
    Set<String> globalPool = {};

    // 1. Proximity Search: Gather candidates near Account labels
    for (int i = 0; i < upperLines.length; i++) {
      if (upperLines[i].contains('ACCOUNT') ||
          upperLines[i].contains('A/C') ||
          upperLines[i].contains('AC NO')) {
        for (int j = i; j < i + 15 && j < lines.length; j++) {
          _extractFromLine(lines[j], upperLines[j], digitRegex, proximityPool);
        }
      }
    }

    // 2. Global Search: Gather all potential candidates
    for (int i = 0; i < lines.length; i++) {
      _extractFromLine(lines[i], upperLines[i], digitRegex, globalPool);
    }

    if (globalPool.isEmpty) return null;

    // 3. Scoring System to distinguish Account No from CIF/MICR
    int getScore(String num) {
      int score = 0;
      // Bonus if found near an account label
      if (proximityPool.contains(num)) score += 50;

      // Bonus for starting with typical account prefixes (1-6)
      if (num.startsWith(RegExp(r'^[123456]'))) score += 20;

      // Heavy penalty for starting with typical CIF/Mobile prefixes (8, 9)
      if (num.startsWith(RegExp(r'^[89]'))) score -= 30;

      return score;
    }

    // 4. Filter by target length if known
    if (targetLength != null) {
      var exactMatches = globalPool
          .where((c) => c.length == targetLength)
          .toList();
      if (exactMatches.isNotEmpty) {
        exactMatches.sort(
          (a, b) => getScore(b).compareTo(getScore(a)),
        ); // Descending
        return exactMatches.first;
      }
    }

    // 5. Fallback if no target length matched (or known)
    var allMatches = globalPool.toList();
    allMatches.sort((a, b) {
      // Prioritize length first (longer is usually account number, not MICR/branch)
      if (a.length != b.length) return b.length.compareTo(a.length);
      // Then use heuristic score
      return getScore(b).compareTo(getScore(a));
    });

    return allMatches.first;
  }

  static void _extractFromLine(
    String line,
    String upperLine,
    RegExp digitRegex,
    Set<String> pool,
  ) {
    // Explicitly ignore lines labeled as other identifiers
    if (upperLine.contains('CIF') ||
        upperLine.contains('CUST ID') ||
        upperLine.contains('CUSTOMER IDENTIFICATION') ||
        upperLine.contains('NOM REG NO') ||
        upperLine.contains('NOMINEE') ||
        upperLine.contains('MICR')) {
      return;
    }

    final normalizedLine = line.replaceAll('O', '0').replaceAll('o', '0');
    for (final match in digitRegex.allMatches(normalizedLine)) {
      final num = match.group(1)!;
      if (_isValidGenericAccount(num)) {
        pool.add(num);
      }
    }
  }

  static bool _isValidGenericAccount(String num) {
    // Filter out 10-digit mobile numbers starting with 6-9
    if (num.length == 10 && RegExp(r'^[6-9]').hasMatch(num)) return false;
    // Filter out 6-digit pincodes
    if (num.length == 6) return false;

    // Filter out numbers with excessive continuous zeros
    if (num.contains('000000')) return false;

    return num.length >= 9 && num.length <= 18;
  }

  // ====================== NAME (Semantic) ======================
  static String? _extractName(List<String> lines, List<String> upperLines) {
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final upper = upperLines[i];

      // Priority 1: Clear "Name" label
      if (upper.contains('NAME') || upper.contains('HOLDER')) {
        // Try to get text after colon or hyphen
        final parts = line.split(RegExp(r'[:\-]+'));
        if (parts.length > 1) {
          String namePart = parts.last.trim();
          if (_isLikelyName(namePart)) return _cleanAndNormalize(namePart);
        } else {
          // If no separator, remove the label words and take the rest
          String namePart = upper
              .replaceAll(RegExp(r'\b(ACCOUNT|A/C|CUSTOMER|NAME|HOLDER)\b'), '')
              .trim();
          if (_isLikelyName(namePart)) return _cleanAndNormalize(namePart);
        }

        // If label is alone on line i, name is often on i+1
        if (i + 1 < lines.length && _isLikelyName(lines[i + 1])) {
          return _cleanAndNormalize(lines[i + 1]);
        }
      }

      // Priority 2: Relationship markers (S/O, D/O, W/O, H/O)
      final relMatch = RegExp(r'\b(S/O|D/O|W/O|H/O)\b').firstMatch(upper);
      if (relMatch != null) {
        final relStr = relMatch.group(1)!;
        final namePart = line.substring(0, upper.indexOf(relStr)).trim();
        if (_isLikelyName(namePart)) {
          return _cleanAndNormalize(namePart);
        }
      }

      // Priority 3: Explicit Titles
      if (RegExp(r'\b(MR|MRS|MS|SHRI|SMT)\b').hasMatch(upper)) {
        if (_isLikelyName(line)) {
          return _cleanAndNormalize(line);
        }
      }
    }

    // Priority 4: Fallback search through all lines for surnames/titles
    for (int i = 0; i < lines.length; i++) {
      if (_isLikelyName(lines[i])) {
        return _cleanAndNormalize(lines[i]);
      }
    }
    return null;
  }

  static bool _isLikelyName(String text) {
    final upper = text.toUpperCase();

    // Clean string for length check (ignore spaces and punctuation)
    final cleaned = upper.replaceAll(RegExp(r'[^A-Z]'), '');
    if (cleaned.length < 4) return false;

    // Filter out geographic noise & banking terms
    if (_geoNoise.any((geo) => upper.contains(geo))) return false;
    if (upper.contains('BANK') ||
        upper.contains('IFSC') ||
        upper.contains('BRANCH') ||
        upper.contains('CIF') ||
        upper.contains('CODE'))
      return false;

    // Filter out lines that look like pure numbers or dates
    if (RegExp(r'^[\d\s/\-.,:]+$').hasMatch(upper)) return false;

    return true;
  }

  static String _cleanAndNormalize(String raw) {
    return raw
        .trim()
        .replaceFirst(
          RegExp(r'^(MR|MRS|MS|SHRI|SMT|SH)\.?\s*', caseSensitive: false),
          '',
        )
        .replaceAll(RegExp(r'[:\-0-9]'), '') // Remove noise characters
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .map(
          (w) =>
              w[0].toUpperCase() +
              (w.length > 1 ? w.substring(1).toLowerCase() : ''),
        )
        .join(' ');
  }
}
