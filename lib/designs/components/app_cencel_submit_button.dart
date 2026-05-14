part of 'app_components_import.dart';

class CancelSubmitButtons extends StatelessWidget {
  final bool useSafeArea;
  final bool isSubmitting;
  final VoidCallback? onSubmit;

  /// If [null], the button will call [Get.back]
  final VoidCallback? onCancel;
  final String? cancelButtonLabel;
  final String? submitButtonLabel;
  final Color? submitButtonColor;
  final Color? cancelButtonColor;

  const CancelSubmitButtons({
    super.key,
    this.onCancel,
    required this.onSubmit,
    this.submitButtonLabel,
    this.cancelButtonLabel,
    this.useSafeArea = true,
    this.isSubmitting = false,
    this.submitButtonColor,
    this.cancelButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    final child = Row(
      children: [
        Expanded(
          child: SecondaryButton(
            label: cancelButtonLabel ?? "Cancel",
            onPress: onCancel ?? Get.back,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: PrimaryButton(
            isLoading: isSubmitting,
            label: submitButtonLabel ?? "Submit",
            onPress: onSubmit,
          ),
        ),
      ],
    );

    return useSafeArea
        ? SafeArea(minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), child: child)
        : child;
  }
}
