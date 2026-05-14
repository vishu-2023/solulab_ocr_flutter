class LuhnValidator {
  LuhnValidator._();
  factory LuhnValidator() => _instance;
  static final LuhnValidator _instance = LuhnValidator._();

  static bool isValidCard(String cardNumber) {
    cardNumber = cardNumber.replaceAll(RegExp(r'\D'), '');
    int sum = 0;
    bool alternate = false;
    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int n = int.parse(cardNumber[i]);
      if (alternate) {
        n *= 2;

        if (n > 9) {
          n -= 9;
        }
      }
      sum += n;
      alternate = !alternate;
    }
    return sum % 10 == 0;
  }
}
