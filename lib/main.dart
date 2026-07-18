import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';
import 'app/bindings/initial_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // Initialize local storage
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final storage = GetStorage();

  @override
  Widget build(BuildContext context) {


    return  GetMaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'PROJEXINO',
  initialBinding: InitialBinding(), // ✅ ONLY HERE
  initialRoute:  Routes.HOME ,
  getPages: AppPages.routes,
);
  }
}
