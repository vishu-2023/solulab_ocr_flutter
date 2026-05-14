# OCR Data Extractor (Flutter)

A Flutter application designed to scan and extract structured data from physical credit/debit cards and bank passbooks using OCR and custom parsing logic.

## Features

1. **Card Scanner**:
   - Scans credit/debit cards using the device camera.
   - Extracts: Card Number, Expiry Date, and Card Holder Name.
   - Masks the card number in the UI (e.g., `XXXX XXXX XXXX 1234`).
   - Validates the card number using the Luhn Algorithm.

2. **Passbook Scanner**:
   - Scans bank passbooks using the device camera.
   - Extracts: Account Holder Name, Account Number, and IFSC Code.
   - Uses context-aware triangulation to filter out noise like phone numbers, pin codes, and invalid dates.

## Setup and Installation

### Prerequisites
- Dart SDK
- Android Studio / Xcode
- Flutter version 3.41.0

### Steps to Run
1. Clone the repository.
2. Run `flutter pub get` to fetch dependencies.
3. Connect a physical device or an emulator with a camera.
4. Run `flutter run` to launch the application.

## Libraries Used

- **`google_mlkit_text_recognition`**: Used for on-device text recognition (OCR) from camera images.
- **`camera`**: Used to access and control the device camera for scanning.
- **`get`**: Used for state management and routing.
- **`shimmer`**: Used for loading animations during data extraction.
- **`flutter_svg`**: Used for rendering SVG icons.

## Assumptions Made

- **Passbook Format**: Assumes that Indian bank passbooks follow standard CBS patterns (e.g., specific lengths for account numbers based on IFSC, specific relationship markers like S/O, D/O).
- **Credit Card Format**: Assumes the card number, expiry date, and name are printed on the same side.
- **Data Quality**: The OCR will occasionally misread characters (e.g., 'O' vs '0', 'I' vs '1'), so the parsing logic actively cleans and normalizes strings before validation.
- **Luhn Algorithm**: Assumes valid cards pass the standard Modulo 10 Luhn check.

## What Was Skipped & Why

- **Backend / Third-Party APIs**: As per the requirements, no backend services or external parsing APIs were used. All parsing and validation (including the Luhn check) are implemented manually.
- **iOS Testing**: The app is primarily configured and tested for Android as per the mandatory platform requirement. iOS is supported by Flutter but specific camera/permission configs may need fine-tuning.
- **Advanced State Restoration**: Simple state management is used. If the app is killed in the background, the state is not persisted locally as there was no requirement for local caching or database storage.

## Testing

Unit tests have been provided for the core parsing logic.
To run the tests:
```bash
flutter test
```

The following are covered:
- `CardParser` extraction accuracy (clean & noisy text).
- `PassbookParser` extraction accuracy and noise filtering.
- `LuhnValidator` verification correctness.
