import 'dart:convert';
import 'package:dealsdray/Screens/homeScreen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Controller/UserInfo.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _referralController = TextEditingController();

  UserInfo user_controller = Get.put(UserInfo());


  late bool _passwordVisible;
  late bool _validate = false;
  late bool UserCreated = false;

  @override
  void initState() {
    _passwordVisible = false;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  Future<void> registerUser(String email, String password, String referralCode) async {
    final String apiUrl = 'http://devapiv4.dealsdray.com/api/v2/user/email/referral';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'referralCode': referralCode,
        'userId': user_controller.UserID
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        UserCreated = true;
      });
      print('Registration successful');
    } else {
      setState(() {
        UserCreated = false;
      });
      print('Registration failed: ${response.body}');
    }
  }

  void _handleRegistration() async {
    if (_formKey.currentState?.validate() ?? false) {
      await registerUser(
        _emailController.text,
        _passwordController.text,
        _referralController.text,
      );

      if (UserCreated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        setState(() {
          _validate = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: _handleRegistration,
        child: Icon(Icons.arrow_forward, color: Colors.white),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 0, top: 20),
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
                    Image.asset('asset/logo.png',
                        height: 250,
                        opacity: AlwaysStoppedAnimation(.5)),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Let's Begin!",
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.roboto(
                          fontSize: 20, //provide in %
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Please enter your credentials to proceed",
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.roboto(
                          fontSize: 16, //provide in %
                          fontWeight: FontWeight.w500,
                          color: Colors.black26,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        errorText: _validate ? "Value Can't Be Empty" : null,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        errorText: _validate ? "Value Can't Be Empty" : null,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.black12,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_passwordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _referralController,
                      decoration: InputDecoration(
                        labelText: 'Referral Code',
                        hintText: "Optional",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
