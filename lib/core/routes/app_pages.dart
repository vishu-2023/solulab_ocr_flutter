import 'package:get/get.dart';
import 'package:solulab_ocr_flutter/designs/screens/camera/camera_view.dart';
import 'package:solulab_ocr_flutter/designs/screens/camera/camera_view_controller.dart';
import 'package:solulab_ocr_flutter/designs/screens/home/home_view.dart';
import 'package:solulab_ocr_flutter/designs/screens/home/home_view_controller.dart';
import 'package:solulab_ocr_flutter/designs/screens/images_view/image_view.dart';
import 'package:solulab_ocr_flutter/designs/screens/images_view/image_view_controller.dart';

part 'app_routes.dart';

class AppPages {
  static final List<GetPage<dynamic>> routes = [..._onlineRoutes, ..._offlineRoutes];
  static List<GetPage<dynamic>> get _onlineRoutes {
    return [
      GetPage(
        name: Paths.HOME,
        page: () => const HomeView(),
        binding: BindingsBuilder(() => Get.lazyPut<HomeViewController>(() => HomeViewController())),
      ),
      GetPage(
        name: Paths.CAMERA,
        page: () => const CameraView(),
        binding: BindingsBuilder(
          () => Get.lazyPut<CameraViewController>(() => CameraViewController()),
        ),
      ),
      GetPage(
        name: Paths.IMAGE_VIEW,
        page: () => const ImageView(),
        binding: BindingsBuilder(
          () => Get.lazyPut<ImageViewController>(() => ImageViewController()),
        ),
      ),
    ];
  }

  static List<GetPage<dynamic>> get _offlineRoutes {
    return [];
  }
}

class BindingsX {
  static BindingsBuilder initialBindings() {
    return BindingsBuilder(() {});
  }
}
