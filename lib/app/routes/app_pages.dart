
import 'package:get/get.dart';
import '../pages/webview_page.dart';
import '../pages/home_page.dart';




class AppPages {
  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomePage(),
    ),
    // GetPage(
    //   name: Routes.ONBOARDING,
    //   page: () => const OnboardingPage(),
    // ),
    GetPage(
      name: Routes.WEBVIEW,
      page: () => WebViewPage(),
    ),
  ];
}

class Routes {
  static const HOME = '/home';
  static const ONBOARDING = '/onboarding';
  static const WEBVIEW = '/webview';
  static const PROFILE = '/profile';
}
