import 'dart:convert';

import 'package:custom_clippers/custom_clippers.dart';

import 'package:flutter/material.dart';
import 'package:salon/pages_usermanagement/forget_otp_page.dart';
import 'package:salon/pages_usermanagement/otp_verification.dart';
import 'package:salon/utils/api.dart';
import 'package:dio/dio.dart';
import 'package:salon/utils/colors.dart';
import 'package:salon/utils/shared_prefrences_helper.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  String? validateEmail(String? email) {
    RegExp emailRegex = RegExp(r'^[\w\.-]+@[\w-]+\.\w{2,3}(\.\w{2,3})?$');
    final isEmailValid = emailRegex.hasMatch(email ?? '');

    if (!isEmailValid) {
      return 'please enter a valid email';
    }
    return null;
  }

  // TextEditingController confirmpass = TextEditingController();
  // bool obsecuretxt = true;
  // bool confrimobsecuretxt = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
        borderSide: BorderSide.none, borderRadius: BorderRadius.circular(5));

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.appbackgroundColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipPath(
                clipper: SinCosineWaveClipper(),
                // borderRadius: const BorderRadius.vertical(bottom: Radius.elliptical(340, 180)),

                child: Container(
                  width: double.infinity,
                  height: 250,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: ExactAssetImage('assets/onboarding3.png'),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Center(
                  child: Text(
                    'Forget password',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Center(
                  child: Text(
                    'Please enter your email. You will receive\na code to create a new password via email',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Center(
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            hintText: 'Enter email id',
                            filled: true,
                            fillColor: Colors.white,
                            focusColor: Colors.white,
                            focusedBorder: inputBorder,
                            enabledBorder: inputBorder,
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: validateEmail,
                        ),
                        const SizedBox(height: 25),
                        InkWell(
                          onTap: () {
                            if (_formkey.currentState!.validate()) {
                              forgetPassAPI(_nameController.text);
                              // Navigator.pushReplacement(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => const ForegetOTPPage(),
                              //   ),
                              // );
                            }
                          },
                          child: !isLoading
                              ? Container(
                                  // // padding: const EdgeInsets.all(32),
                                  // margin: const EdgeInsets.symmetric(horizontal: 30),
                                  height: 50,
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: const Center(
                                    child: Text(
                                      'SEND CODE',
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 0, 11, 70),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              : CircularProgressIndicator(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> forgetPassAPI(String email) async {
    setState(() {
      isLoading = true; // Add this line
    });
    print('forgetPassAPI Function Called');
    print("$email");
    final String apiUrl = APIEndPoints.forgetPass;
    var dio = Dio();
    try {
      var map = Map<String, dynamic>();
      map['email'] = email;

      FormData formData = new FormData.fromMap(map);
      var res = await dio.post(apiUrl, data: formData);
      print("object : ${res.data}");
      // var res = await http.post(
      //   Uri.parse(apiUrl),
      //   body: map,
      // );
      // print("Data sent");
      if (res.statusCode == 200) {
        print(res.statusCode);
        await SharedPrefs.saveEmail(email);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ForegetOTPPage(),
          ),
        );
        print('Success: ${res.data}');
      } else if (res.statusCode == 400) {
        print('Client Error: ${res.statusMessage}');
      } else {
        print('Server Error: ${res.statusCode}');
      }
      // if (jsonDecode(res.data)['status'] == 'success') {
      //   await SharedPrefs.saveEmail(email);
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => const AskMobileNumberPage(),
      //     ),
      //   );
      // }
      return res;
    } catch (e, stackTrace) {
      print('Error: $e');
      print('StackTrace: $stackTrace');
      return null;
    } finally {
      setState(() {
        isLoading = false; // Add this line
      });
    }
  }
}
