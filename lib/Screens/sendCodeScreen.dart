import 'dart:convert';
import 'package:dealsdray/Screens/homeScreen.dart';
import 'package:dealsdray/Screens/verificationScreen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Controller/DeviceInfo.dart';
import '../Controller/UserInfo.dart';

class SendCodeScreen extends StatefulWidget {
  @override
  _SendCodeScreenState createState() => _SendCodeScreenState();
}

class _SendCodeScreenState extends State<SendCodeScreen> {
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isPhoneSelected = true;

  DeviceInfo deviceController = Get.put(DeviceInfo());
  UserInfo userController = Get.put(UserInfo());

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> createUserId() async {
    final String apiUrl = 'http://devapiv4.dealsdray.com/api/v2/user/otp';
    final String deviceId = deviceController.DeviceID;

    final Map<String, String> body = {
      _isPhoneSelected ? 'mobileNumber' : 'email': _isPhoneSelected ? _phoneController.text : _emailController.text,
      'deviceId': deviceId,
    };
    if (_phoneController.text == null || deviceId == null) {
      print('Error: mobileNumber or deviceId is null');
      return;
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      // Handle success response

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print('OTP sent successfully: ${responseData['message']}');
      // Process other fields as needed
    } else {
      // Handle error response
      print(deviceId);
      print(_phoneController.text);
      print('Failed to send OTP: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.only(left: 10),
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              FontAwesome5Solid.angle_left,
              color: Colors.black26,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: [
                Image.asset(
                  'asset/logo.png', // Replace with your logo asset
                  height: 250,
                  opacity: AlwaysStoppedAnimation(.5),
                ),
                Container(
                  width: 168,
                  height: 40,
                  padding: EdgeInsets.zero,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(120)),
                    color: Colors.grey,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => setState(() => _isPhoneSelected = true),
                        child: Text(
                          'Phone',
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          backgroundColor: _isPhoneSelected ? Colors.red : Colors.grey,
                        ),
                      ),
                      TextButton(
                        onPressed: () => setState(() => _isPhoneSelected = false),
                        child: Text(
                          'Email',
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          backgroundColor: !_isPhoneSelected ? Colors.red : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Glad to see you!",
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, top: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Please provide your ${_isPhoneSelected ? 'phone number' : 'email'}",
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black26,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                _isPhoneSelected
                    ? TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                  ),
                  keyboardType: TextInputType.phone,
                )
                    : TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 30),
                TextButton(
                  onPressed: () async {
                    await createUserId();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) => OtpVerificationScreen()),
                    );
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.redAccent,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 60),
                    child: const Text(
                      'Send code',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
                    );
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.redAccent,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 60),
                    child: const Text(
                      'Home screen',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
