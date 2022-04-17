import 'package:blockchain/services/contract_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HomeController extends GetxController{
  /// ------------------------
  /// SERVICES
  /// ------------------------
  final contractService = Get.find<ContractService>();
  /// ------------------------
  /// VARIABLES
  /// ------------------------
  late TextEditingController _textController;

  /// ------------------------
  /// GETTERS
  /// ------------------------
  TextEditingController get textController => _textController;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _textController = TextEditingController();
  }

  void send(){
    var num = int.parse(textController.text);
    var numBlock = BigInt.from(num);

    contractService.setStoredData(numBlock);
  }
}