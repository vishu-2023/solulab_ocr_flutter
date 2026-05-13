import 'package:get/get.dart';

class AppPages {
  static final List<GetPage<dynamic>> routes = [..._onlineRoutes, ..._offlineRoutes];
  static List<GetPage<dynamic>> get _onlineRoutes {
    return [];
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
