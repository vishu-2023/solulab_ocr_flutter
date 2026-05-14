import 'package:flutter_test/flutter_test.dart';
import 'package:solulab_ocr_flutter/core/services/card_parcing_service.dart';
import 'package:solulab_ocr_flutter/core/services/passbook_parcer_service.dart';
import 'package:solulab_ocr_flutter/core/services/luhn_validator_service.dart';

void main() {
  group('Luhn Validator Tests', () {
    test('Valid card number passes Luhn check', () {
      // Test with a known valid prefix and check digit format
      expect(LuhnValidator.isValidCard('49927398716'), isTrue);
      // Let's use a standard test card or a well-known structure.
      // E.g., generic test VISA
      expect(LuhnValidator.isValidCard('4111 1111 1111 1111'), isTrue);
    });

    test('Invalid card number fails Luhn check', () {
      expect(LuhnValidator.isValidCard('4111 1111 1111 1112'), isFalse);
    });
  });

  group('Card Parser Tests', () {
    test('Extracts valid card details from clean OCR text', () {
      final rawText = '''
BANK NAME
4111 1111 1111 1111
VALID THRU 12/25
JOHN DOE
VISA
''';
      final details = CardParser.parseCard(rawText);
      expect(details.cardNumber, '4111111111111111');
      expect(details.expiryDate, '12/25');
      expect(details.cardHolderName, 'JOHN DOE');
    });

    test('Extracts valid card details from noisy OCR text', () {
      final rawText = '''
CREDIT CARD
4111 1111 1111 1111
12-25
NAME: ALICE SMITH
''';
      final details = CardParser.parseCard(rawText);
      expect(details.cardNumber, '4111111111111111');
      expect(details.expiryDate, '12-25');
      expect(details.cardHolderName, 'ALICE SMITH');
    });
  });

  group('Passbook Parser Tests', () {
    test('Extracts valid passbook details from OCR text', () {
      final rawText = '''
STATE BANK OF INDIA
BRANCH: GANDHINAGAR
IFSC: SBIN0001234
NAME: VIKRAM SARABHAI
A/C NO: 12345678901
''';
      final details = PassbookParser.parsePassbook(rawText);
      expect(details.ifscCode, 'SBIN0001234');
      expect(details.accountNumber, '12345678901');
      expect(details.accountHolderName, 'Vikram Sarabhai');
    });

    test('Extracts passbook details ignoring noise', () {
      final rawText = '''
BANK OF BARODA
IFSC BARB0001234
VIKRAM CHANDRA
S/O RAMESH CHANDRA
ACCOUNT NUMBER
09876543211234
''';
      final details = PassbookParser.parsePassbook(rawText);
      expect(details.ifscCode, 'BARB0001234');
      expect(details.accountNumber, '09876543211234');
      expect(details.accountHolderName, 'Vikram Chandra');
    });
  });
}
