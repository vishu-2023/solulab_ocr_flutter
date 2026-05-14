import 'package:solulab_ocr_flutter/core/models/card_details_model.dart';
import 'package:solulab_ocr_flutter/core/services/luhn_validator_service.dart';

class CardParser {
  CardParser._();
  factory CardParser() => _instance;
  static final CardParser _instance = CardParser._();

  // Known non-name keywords to filter out
  static const _invalidNameKeywords = [
    'VALID',
    'THRU',
    'THROUGH',
    'EXPIRES',
    'EXPIRY',
    'CARD',
    'BANK',
    'VISA',
    'MASTERCARD',
    'RUPAY',
    'MAESTRO',
    'AMEX',
    'DISCOVER',
    'DEBIT',
    'CREDIT',
    'PREPAID',
    'GLOBAL',
    'MEMBER',
    'SINCE',
    'PLATINUM',
    'GOLD',
    'CLASSIC',
    'SIGNATURE',
    'INTERNATIONAL',
    'NETWORK',
    'OSBI',
    'SBI',
    'HDFC',
    'ICICI',
    'AXIS',
    'KOTAK',
    'PNB',
    'BOB',
    'CANARA',
    'UNION',
  ];

  static CardDetails parseCard(String rawText) {
    final lines = rawText.split('\n');
    String? cardNumber = _extractCardNumber(rawText, lines);
    String? expiry = _extractExpiry(rawText);
    String? holderName = _extractHolderName(lines);

    return CardDetails(cardNumber: cardNumber, expiryDate: expiry, cardHolderName: holderName);
  }

  // ─── CARD NUMBER ────────────────────────────────────────────────────────────

  static String? _extractCardNumber(String rawText, List<String> lines) {
    // Clean only for number extraction (O→0 etc.)
    final cleanedText = _cleanForNumbers(rawText);
    final cleanedLines = cleanedText.split('\n');

    final cardRegex = RegExp(r'(?:\d[\s\-]?){13,19}');

    for (final line in cleanedLines) {
      final match = cardRegex.firstMatch(line);
      if (match != null) {
        final number = match.group(0)!.replaceAll(RegExp(r'[^0-9]'), '');
        if (number.length >= 13 && number.length <= 19 && LuhnValidator.isValidCard(number)) {
          return number;
        }
      }
    }

    // Fallback: try groups like "6522 9401 9969 7254"
    final groupedRegex = RegExp(r'\d{4}[\s\-]\d{4}[\s\-]\d{4}[\s\-]\d{4}');
    final groupedMatch = groupedRegex.firstMatch(_cleanForNumbers(rawText));
    if (groupedMatch != null) {
      final number = groupedMatch.group(0)!.replaceAll(RegExp(r'[^0-9]'), '');
      if (LuhnValidator.isValidCard(number)) return number;
    }

    return null;
  }

  // ─── EXPIRY DATE ─────────────────────────────────────────────────────────────

  static String? _extractExpiry(String rawText) {
    // Handles: 07/26, 07-26, 07/2026, 0726
    final expiryRegex = RegExp(r'\b(0[1-9]|1[0-2])[\/\-](\d{2}|\d{4})\b');
    final match = expiryRegex.firstMatch(rawText);
    if (match != null) return match.group(0);

    // Fallback: look for VALID THRU pattern and grab nearby date
    final validThruRegex = RegExp(
      r'(?:VALID\s*(?:THRU|THROUGH|TILL)?)\s*(\d{2}[\/\-]\d{2,4})',
      caseSensitive: false,
    );
    final validMatch = validThruRegex.firstMatch(rawText);
    if (validMatch != null) return validMatch.group(1);

    return null;
  }

  // ─── HOLDER NAME ─────────────────────────────────────────────────────────────

  static String? _extractHolderName(List<String> lines) {
    // Strategy 1: Line after "VALID THRU / EXPIRES" line
    String? nameFromValidThru = _extractNameNearValidThru(lines);
    if (nameFromValidThru != null) return nameFromValidThru;

    // Strategy 2: Keyword "NAME:" prefix
    String? nameFromKeyword = _extractNameFromKeyword(lines);
    if (nameFromKeyword != null) return nameFromKeyword;

    // Strategy 3: General heuristic — all-caps name line
    String? nameFromHeuristic = _extractNameHeuristic(lines);
    if (nameFromHeuristic != null) return nameFromHeuristic;

    return null;
  }

  /// Strategy 1: Name usually appears just after "VALID THRU" or expiry date line
  static String? _extractNameNearValidThru(List<String> lines) {
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].toUpperCase();
      if (line.contains('VALID') || line.contains('THRU') || line.contains('EXPIRES')) {
        // Check next 1-2 lines for a name
        for (int j = i + 1; j <= i + 2 && j < lines.length; j++) {
          final candidate = _validateNameLine(lines[j]);
          if (candidate != null) return candidate;
        }
      }
    }

    // Also check: line that contains expiry date — name may be on same or next line
    final expiryRegex = RegExp(r'\b(0[1-9]|1[0-2])[\/\-]\d{2,4}\b');
    for (int i = 0; i < lines.length; i++) {
      if (expiryRegex.hasMatch(lines[i])) {
        // Check if name is on same line (after expiry)
        final afterExpiry = lines[i].replaceAll(expiryRegex, '').trim();
        final candidate = _validateNameLine(afterExpiry);
        if (candidate != null) return candidate;

        // Check next line
        if (i + 1 < lines.length) {
          final next = _validateNameLine(lines[i + 1]);
          if (next != null) return next;
        }
      }
    }

    return null;
  }

  /// Strategy 2: Lines starting with "NAME:" or "CARD HOLDER:" etc.
  static String? _extractNameFromKeyword(List<String> lines) {
    final keywordRegex = RegExp(r'^(?:NAME|CARD\s*HOLDER|HOLDER)[:\s]+(.+)$', caseSensitive: false);
    for (final line in lines) {
      final match = keywordRegex.firstMatch(line.trim());
      if (match != null) {
        final candidate = _validateNameLine(match.group(1)!);
        if (candidate != null) return candidate;
      }
    }
    return null;
  }

  /// Strategy 3: General heuristic for name lines
  static String? _extractNameHeuristic(List<String> lines) {
    for (final line in lines) {
      final candidate = _validateNameLine(line);
      if (candidate != null) return candidate;
    }
    return null;
  }

  /// Core name validation — returns cleaned name or null
  static String? _validateNameLine(String line) {
    final clean = line.trim().replaceAll(RegExp(r'\s+'), ' ');

    // Must be 5–35 chars, only letters and spaces
    if (!RegExp(r'^[A-Za-z ]{5,35}$').hasMatch(clean)) return null;

    final upper = clean.toUpperCase();

    // Must have at least 2 words (first + last name)
    final words = upper.split(' ').where((w) => w.isNotEmpty).toList();
    if (words.length < 2) return null;

    // Filter out if it contains any known non-name keyword
    for (final keyword in _invalidNameKeywords) {
      if (words.contains(keyword)) return null;
    }

    // Filter out if any word is 1 char (likely noise),
    // but allow initials like "A" only if 3+ words total
    if (words.length < 3) {
      if (words.any((w) => w.length <= 1)) return null;
    }

    return upper;
  }

  // ─── TEXT CLEANING (only for number extraction) ──────────────────────────────

  static String _cleanForNumbers(String text) {
    return text
        .replaceAll('O', '0')
        .replaceAll('o', '0')
        .replaceAll('I', '1')
        .replaceAll('l', '1')
        .replaceAll('B', '8')
        .replaceAll('S', '5')
        .replaceAll('Z', '2');
  }
}
