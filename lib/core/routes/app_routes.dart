// ignore_for_file: constant_identifier_names, non_constant_identifier_names
part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const String HOME = Paths.HOME;
  static const String CAMERA = Paths.CAMERA;
  static const String IMAGE_VIEW = Paths.IMAGE_VIEW;
  static const String SPLASH = Paths.SPLASH;
}

abstract class Paths {
  static const String HOME = '/home';
  static const String CAMERA = '/camera';
  static const String IMAGE_VIEW = '/image-view';
  static const SPLASH = '/splash';
}
