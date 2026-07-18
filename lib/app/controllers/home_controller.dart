import 'package:get/get.dart';

class HomeController extends GetxController {
  // you can add state, methods etc.
  RxInt selectedIndex = 0.obs;

  void changeTab(int idx) {
    selectedIndex.value = idx;
  }
}
