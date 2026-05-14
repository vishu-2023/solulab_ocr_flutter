class BankDetails {
  final String? accountHolderName;
  final String? accountNumber;
  final String? ifscCode;

  BankDetails({this.accountHolderName, this.accountNumber, this.ifscCode});
  @override
  String toString() {
    return '''
BankDetails(
  accountHolderName: $accountHolderName,
  accountNumber: $accountNumber,
  ifscCode: $ifscCode,
)
''';
  }
}
