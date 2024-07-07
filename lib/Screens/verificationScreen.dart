import 'dart:convert';
import 'package:dealsdray/Screens/DashboardScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../Controller/DeviceInfo.dart';
import '../Controller/UserInfo.dart';

class OtpVerificationScreen extends StatefulWidget {
  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpControllers = List.generate(4, (index) => TextEditingController());
  CountdownTimerController? _countdownController;
  int _endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60; // 60 seconds from now
  DeviceInfo device_controller = Get.put(DeviceInfo());
  UserInfo user_controller = Get.put(UserInfo());

  @override
  void initState() {
    super.initState();
    _countdownController = CountdownTimerController(endTime: _endTime, onEnd: _onEnd);
  }

  @override
  void dispose() {
    _otpControllers.forEach((controller) => controller.dispose());
    _countdownController?.dispose();
    super.dispose();
  }

  void _onEnd() {
    // Handle OTP timer end
    print('OTP timer ended');
  }

  Future<void> ResendOTP() async {
    final String apiUrl = 'http://devapiv4.dealsdray.com/api/v2/user/device/add';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "mobileNumber": user_controller.set_phoneNo,
        "deviceId": device_controller.DeviceID
      }),
    );

    if (response.statusCode == 200) {
      // Handle success response
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print('Device ID created successfully: ${responseData}');
      // Process other fields as needed
    } else {
      // Handle error response
      print('Failed to create Device ID: ${response.body}');
    }
  }

  void _resendOtp() {
    setState(() {
      _endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60; // Resend OTP and reset timer
      _countdownController = CountdownTimerController(endTime: _endTime, onEnd: _onEnd);
      ResendOTP();
    });
  }

  Future<void> verifyOtp(String otp) async {
    final String apiUrl = 'http://devapiv4.dealsdray.com/api/v2/user/otp/verification';
    final String deviceId = device_controller.DeviceID; // Fetch the device ID
    final String userId = user_controller.UserID; // Fetch the user ID

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "otp": otp,
        "deviceId": deviceId,
        "userId": userId,
      }),
    );

    if (response.statusCode == 200) {
      // Handle success response
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print('OTP verified successfully: ${responseData}');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    } else {
      // Handle error response
      print(deviceId);
      print(userId);
      print('Failed to verify OTP: ${response.body}');
    }
  }

  void _verifyOtp() {
    final otp = _otpControllers.map((controller) => controller.text).join();
    print('Entered OTP: $otp');
    verifyOtp(otp);
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
            onPressed: () {
              Navigator.pop(context);
            },
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
          children: [
            Image.asset('asset/logo.png', height: 260), // OTP sent image
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                "OTP Verification",
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
              margin: const EdgeInsets.only(left: 10),
              padding: EdgeInsets.only(right: 30),
              alignment: Alignment.centerLeft,
              child: Text(
                "We have sent a unique OTP number to your mobile +9122396696",
                maxLines: 2,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.left,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black26,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 50,
                  child: TextField(
                    controller: _otpControllers[index],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                  ),
                );
              }),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 25),
                  alignment: Alignment.centerLeft,
                  child: CountdownTimer(
                    controller: _countdownController,
                    endTime: _endTime,
                    widgetBuilder: (_, time) {
                      if (time == null) {
                        return TextButton(
                          onPressed: _resendOtp,
                          child: Text('Resend OTP', style: TextStyle(color: Colors.black26)),
                        );
                      }
                      return Text('Time : ${time.sec}s', style: TextStyle(color: Colors.black26));
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 120),
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _resendOtp,
                    child: Text('Send Again', style: TextStyle(color: Colors.black26)),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 100),
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _verifyOtp,
                child: Text('Verify OTP', style: TextStyle(color: Colors.blue)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
