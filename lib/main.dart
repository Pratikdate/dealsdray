import 'dart:async';

import 'package:dealsdray/Screens/sendCodeScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'Controller/DeviceInfo.dart';
import 'Screens/RegistrationScreen.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  DeviceInfo controller = Get.put(DeviceInfo());

  @override
  void initState() {
    super.initState();
    IntentHandler();
    createDeviceId();
  }


  void IntentHandler(){

    Timer(
        const Duration(seconds: 2),
            () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => SendCodeScreen())));

  }


  Future<void> createDeviceId() async {
    final String apiUrl = 'http://devapiv4.dealsdray.com/api/v2/user/device/add';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },

    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      controller.DeviceID=responseData["data"]["deviceId"];
      print('Device ID created successfully ${responseData["data"]["deviceId"]}');


    } else {
      print('Failed to create Device ID: ${response.body[1]}');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 40),
      child: Align(
            alignment: Alignment.bottomCenter,
            child:Image.asset("asset/logo.png"),
      ),
    );
  }
}
