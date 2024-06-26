// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:custom_clippers/custom_clippers.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:salon/pages_usermanagement/forget_password_page.dart';

import 'package:salon/pages_usermanagement/signup_page.dart';

import 'package:salon/utils/colors.dart';
import 'package:salon/widgets/shared_functions.dart';

import '../features/home_page.dart';
import '../utils/api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  String? validateEmail(String? email) {
    RegExp emailRegex = RegExp(r'^[\w\.-]+@[\w-]+\.\w{2,3}(\.\w{2,3})?$');
    final isEmailValid = emailRegex.hasMatch(email ?? '');

    if (!isEmailValid) {
      return 'please enter a valid email';
    }
    return null;
  }

  TextEditingController confirmpass = TextEditingController();
  bool obsecuretxt = true;

  bool isChecked = false;
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
                    'Sign in Account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Center(
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text(
                              'Email',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            hintText: 'Enter mail Id',
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
                        const SizedBox(height: 20),
                        const Row(
                          children: [
                            ///
                            Text(
                              'Password',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            suffixIcon: GestureDetector(
                              child: obsecuretxt
                                  ? const Icon(
                                      Icons.visibility_off,
                                      size: 16,
                                    )
                                  : const Icon(
                                      Icons.visibility,
                                      size: 16,
                                    ),
                              onTap: () {
                                setState(() {
                                  print(obsecuretxt); 
                                  obsecuretxt = !obsecuretxt;
                                });
                              },
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            hintText: 'Type password',
                            filled: true,
                            fillColor: Colors.white,
                            focusColor: Colors.white,
                            focusedBorder: inputBorder,
                            enabledBorder: inputBorder,
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          obscureText: obsecuretxt,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "please Enter your password";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgetPasswordPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Forget your password',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                              ),
                            ]),
                        const SizedBox(height: 25),
                        InkWell(
                          onTap: () {
                            if (_formkey.currentState!.validate()) {
                              doLogin();
                            }
                          },
                          child: Container(
                            // // padding: const EdgeInsets.all(32),
                            // margin: const EdgeInsets.symmetric(horizontal: 30),
                            height: 50,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: isLoading
                                ? appLoader()
                                : const Center(
                                    child: Text(
                                    'SIGN IN',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 0, 11, 70),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  )),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have an account?',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white54),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Sign up',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            )
                          ],
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

  void doLogin() async {
    setState(() {
      isLoading = true;
    });
    final String apiUrl = APIEndPoints.login;
    var map = <String, dynamic>{};
    map['email'] = _nameController.text;
    map['password'] = _passwordController.text;
    try {
      var res = await http.post(
        Uri.parse(apiUrl),
        body: map,
      );
      if (res.statusCode == 200) {
        print('Success: ${res.body}');
      } else if (res.statusCode == 400) {
        print('Client Error: ${res.body}');
      } else {
        print('Server Error: ${res.statusCode}');
      }
      if (jsonDecode(res.body)['status'] == 'success') {
        setState(() {
          isLoading = false;
        });
        toastify("Logged in successfully");
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      }
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
