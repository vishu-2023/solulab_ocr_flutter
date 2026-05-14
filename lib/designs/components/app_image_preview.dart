part of 'app_components_import.dart';

class ImagePreviewCard extends StatelessWidget {
  const ImagePreviewCard({super.key, required this.imagePath, this.height});
  final String imagePath;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: double.infinity,
          height: height ?? 390,
          child: Image.file(File(imagePath), fit: BoxFit.fill),
        ),
      ).defaultContainer(),
    );
  }
}
