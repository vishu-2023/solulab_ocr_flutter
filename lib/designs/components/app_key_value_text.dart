part of 'app_components_import.dart';

class AppKeyValueText extends StatelessWidget {
  final String title;
  final String value;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;
  final int? maxLine;

  const AppKeyValueText({
    super.key,
    required this.title,
    required this.value,
    this.titleStyle,
    this.valueStyle,
    this.maxLine,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              title,
              style:
                  titleStyle ??
                  TextThemeX().text14.copyWith(color: whiteColor.withAlpha(140)).medium,
            ),
          ),

          Expanded(
            child: Text(
              value,
              maxLines: maxLine,
              style: valueStyle ?? TextThemeX().text16.copyWith(color: whiteColor).semiBold,
            ),
          ),
        ],
      ),
    );
  }
}
