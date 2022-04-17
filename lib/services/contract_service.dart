import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:blockchain/constants/constants.dart';
import 'package:get/get.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class ContractService extends GetxService {
  /// ------------------------
  /// VARIABLES
  /// ------------------------
  late final Web3Client _client;
  late String _abiCode;

  late EthereumAddress _contractAddress;
  late EthPrivateKey _credentials;

  late DeployedContract _contract;
  late ContractFunction _funGetStoredData;
  late ContractFunction _funSetStoredData;
  late BigInt _numberFromBlockchain;

  final Rx<bool> _isLoading = true.obs;

  /// ------------------------
  /// GETTERS
  /// ------------------------
  Web3Client get client => _client;
  String get abiCode => _abiCode;

  EthereumAddress get contractAddress => _contractAddress;
  EthPrivateKey get credentials => _credentials;
  DeployedContract get contract => _contract;
  ContractFunction get funGetStoredData => _funGetStoredData;
  ContractFunction get funSetStoredData => _funSetStoredData;
  BigInt get numberFromBlockchain => _numberFromBlockchain;

  bool get isLoading => _isLoading.value;

  /// ------------------------
  /// SETTERS
  /// ------------------------
  set client(Web3Client value) => _client = value;
  set abiCode(String value) => _abiCode = value;

  set contractAddress(EthereumAddress value) => _contractAddress = value;
  set credentials(EthPrivateKey value) => _credentials = value;
  set contract(DeployedContract value) => _contract = value;
  set funGetStoredData(ContractFunction value) => _funGetStoredData = value;
  set funSetStoredData(ContractFunction value) => _funSetStoredData = value;

  set isLoading(bool value) => _isLoading.value = value;

  /// ------------------------
  /// INIT
  /// ------------------------
  @override
  Future<void> onInit() async {
    super.onInit();
    await _initialSetup();
  }

  Future<void> _initialSetup() async {
    // establish a connection to the ethereum rpc node.
    _client =
        Web3Client(BlockchainConstants.rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(BlockchainConstants.wsUrl)
          .cast<String>();
    });

    await getAbi();
    getCredentials();
    print("contract adr : $contractAddress");
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    // Reading the contract abi
    String abiStringFile =
        await rootBundle.loadString("src/artifacts/SimpleStorage.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);

    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
  }

  void getCredentials() {
    _credentials = EthPrivateKey.fromHex(BlockchainConstants.privateKey);
  }

  Future<void> getDeployedContract() async {
    // Telling Web3dart where our contract is declared.
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "SimpleStorage"), _contractAddress);

    // Extracting the functions, declared in contract.
    _funGetStoredData = _contract.function("get");
    _funSetStoredData = _contract.function("set");

    //load the number from blockchain
    getStoredData();
  }

  Future<void> getStoredData() async {
    // Getting the current storedData declared in the smart contract.
    var currentStoredData = await _client
        .call(contract: _contract, function: _funGetStoredData, params: []);
    _numberFromBlockchain = currentStoredData[0];

    log("stored data ${currentStoredData[0]}");
    isLoading = false;
  }

  Future<void> setStoredData(BigInt number) async {
    // Setting the number(defined by user)
    isLoading = true;

    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _funSetStoredData,
            parameters: [number]));

    getStoredData();
  }
}
