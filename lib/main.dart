import 'package:blockchain/home_screen/home_controller.dart';
import 'package:blockchain/home_screen/home_screen.dart';
import 'package:blockchain/services/contract_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initServices();
  runApp(const MyApp());
}

void initServices() {
  Get.lazyPut(()=>ContractService());
  Get.lazyPut(()=>HomeController());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Blockchain',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
