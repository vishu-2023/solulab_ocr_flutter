part of 'app_components_import.dart';

class AppButton extends StatefulWidget {
  final String? label;
  final Color? labelColor;
  final bool isLoading;
  final Color? backgroundColor;
  final double borderRadius;
  final Color? loaderColor;
  final Color? borderColor;
  final Widget? child;
  final Widget? leading;
  final Widget? trailing;
  final double? height;
  final double? width;
  final double? labelFontSize;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final ShapeBorder? shape;

  const AppButton({
    super.key,
    this.label,
    this.labelColor,
    this.isLoading = false,
    this.backgroundColor,
    this.borderRadius = 0,
    this.loaderColor,
    this.borderColor,
    this.child,
    this.leading,
    this.trailing,
    this.height = defaultButttonHeight,
    this.width,
    this.labelFontSize,
    this.onPressed,
    this.padding,
    this.shape,
  }) : assert(label != null, "Label is required");
  static Widget loader({Color? color}) {
    return Center(
      child: SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: color != null ? AlwaysStoppedAnimation<Color>(color) : null,
        ),
      ),
    );
  }

  static const double defaultButttonHeight = 55;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 100),
          lowerBound: 0.0,
          upperBound: 0.05,
        )..addListener(() {
          setState(() {});
        });
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget child;
    if (widget.child != null) {
      child = widget.child!;
    } else {
      child = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.leading != null) widget.leading!,
          Text(
            widget.label!,
            style: TextThemeX().text16.copyWith(
              letterSpacing: 0,
              fontSize: widget.labelFontSize,
              color: widget.labelColor,
            ),
          ),
          if (widget.trailing != null) widget.trailing!,
        ],
      );
    }

    final ShapeBorder? shape;
    if (widget.shape != null) {
      shape = widget.shape;
    } else {
      shape = RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(widget.borderRadius),
        side: widget.borderColor != null ? BorderSide(color: widget.borderColor!) : BorderSide.none,
      );
    }

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Transform.scale(
        scale: _scaleAnimation.value,
        child: SizedBox(
          height: widget.height,
          width: widget.width,
          child: MaterialButton(
            onPressed: widget.onPressed,
            height: widget.height,
            shape: shape,
            padding: widget.padding,
            color: widget.backgroundColor,
            disabledColor: widget.backgroundColor?.withOpacity(0.5),
            highlightElevation: 0,
            child: widget.isLoading ? AppButton.loader(color: widget.loaderColor) : child,
          ),
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPress,
    required this.label,
    this.isLoading = false,
  });
  final VoidCallback onPress;
  final String label;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return AppButton(
      isLoading: isLoading,
      label: label,
      onPressed: isLoading ? null : onPress,
      backgroundColor: primaryColor,
      labelColor: whiteColor,
      loaderColor: whiteColor,
      borderRadius: 12,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.onPress,
    required this.label,
    this.isLoading = false,
    this.labelColor,
  });
  final VoidCallback onPress;
  final String label;
  final bool isLoading;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      isLoading: isLoading,
      label: label,
      onPressed: isLoading ? null : onPress,
      backgroundColor: Colors.transparent,
      labelColor: primaryColor,
      borderColor: primaryColor,
    );
  }
}
