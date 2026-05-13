part of 'app_components_import.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onPress});
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPress ?? () => Navigator.pop(context),
      icon: SvgPicture.asset(
        AppIcons.arrowBack,
        matchTextDirection: true,
        colorFilter: ColorFilter.mode(whiteColor, BlendMode.srcIn),
      ),
    );
  }
}
