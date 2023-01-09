import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:visitora/colors/app_colors.dart';
import 'package:visitora/managers/authentication_manager.dart';
import 'package:visitora/screens/signin_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController controller = TextEditingController();
  String _email = "";
  String _password = "";
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: w,
                  height: h * 0.25,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/oradea_intro.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: w,
                  margin: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Let\'s visit Oradea!',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: AppColors.mainDarker,
                        ),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (String value) {
                          _email = value;
                        },
                        decoration: InputDecoration(
                          hintText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                          focusColor: AppColors.mainDarker,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                            borderSide: const BorderSide(
                              color: AppColors.mainDarker,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        obscureText: true,
                        onChanged: (String value) {
                          _password = value;
                        },
                        decoration: InputDecoration(
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                          focusColor: AppColors.mainDarker,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(35),
                              borderSide: const BorderSide(
                                color: AppColors.mainDarker,
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 90,
                      ),
                      SizedBox(
                        width: w,
                        height: h * 0.05,
                        child: Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: AppColors.mainDarker,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Log in',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              bool isValid = validateFields();
                              bool emailIsValid =
                                  EmailValidator.validate(_email);
                              if (!emailIsValid) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Email should look like this: test@domain.com'),
                                  ),
                                );
                              } else if (isValid) {
                                authenticateUser();
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: TextButton(
                          style: TextButton.styleFrom(
                              primary: AppColors.mainDarker),
                          child: const Text("Create Account"),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignInScreen()));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void authenticateUser() {
    AuthenticationManager authManager = AuthenticationManager();
    authManager.logInUser(_email, _password, context);
  }

  bool validateFields() {
    if (_email.isNotEmpty || _password.isNotEmpty || _password.length >= 8) {
      authenticateUser();
      return true;
    } else if (_password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: AppColors.mainDarker,
          content: Text('Password must have at least 8 characters!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: AppColors.mainDarker,
          content: Text('Email and password fields must be filled!')));
    }
    return false;
  }
}
