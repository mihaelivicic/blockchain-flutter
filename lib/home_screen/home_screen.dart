import 'package:blockchain/home_screen/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final _controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Obx(
                () => Container(
                    child: _controller.contractService.isLoading
                        ? const Text("Loading number from blockchain")
                        : Column(
                            children: [
                              const Text(
                                "Current number on the blockchain: ",
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                _controller.contractService.numberFromBlockchain
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              )
                            ],
                          )),
              ),
              const SizedBox(
                height: 70,
              ),
              const Text("Enter your number"),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _controller.textController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Number',
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: _controller.send,
                child: const Text("Send to blockchain"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
