import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_meal_app/components/back_btn.dart';
import 'package:my_meal_app/pages/home_page.dart';
import '../components/background_image.dart';
import '../constants.dart';
import '../hive/hive_app_helper.dart';
import '../utils/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formGlobalKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _obscureText = true;
  bool _loading = false;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _login(){
    setState(() {
      _loading = true;
    });
    Future.delayed(const Duration(seconds: 3), () async {
      bool isLogedIn = await HiveAppHelper().login(_email.text, _password.text);
      Fluttertoast.showToast(msg: isLogedIn ? loginSuccess : loginFailed);
      _email.clear();
      _password.clear();
      setState(() {
        _loading = false;
      });
      if (isLogedIn) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomePage()),
              (Route<dynamic> route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          const BackgroundImage(imageResource: "assets/images/signin_poster.jpg"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
                key: formGlobalKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const Text(
                      welcomeBack,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      loginTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      key: const Key('emailField'),
                      controller: _email,
                      readOnly: _loading,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                          color: Colors.white
                      ),
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      decoration: InputDecoration(
                          labelText: email,
                          labelStyle: const TextStyle(
                              color: Colors.white
                          ),
                          fillColor: Colors.black.withOpacity(0.2),
                          filled: true,
                          prefixIcon: const Icon(Icons.email_outlined, color: mealColor),
                          contentPadding: const EdgeInsets.all(15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: email,
                          hintStyle: const TextStyle(
                              fontSize: 14,
                              color: Colors.white
                          )
                      ),
                      validator: (value) => (value!.isEmpty) ? email : !isEmailValid(value) ? emailNotValid : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const Key('passwordField'),
                      controller: _password,
                      readOnly: _loading,
                      keyboardType: TextInputType.text,
                      obscureText: _obscureText,
                      style: const TextStyle(
                          color: Colors.white
                      ),
                      textInputAction: TextInputAction.done,
                      autocorrect: false,
                      decoration: InputDecoration(
                          labelText: password,
                          labelStyle: const TextStyle(
                              color: Colors.white
                          ),
                          fillColor: Colors.black.withOpacity(0.2),
                          filled: true,
                          prefixIcon: const Icon(Icons.lock_outlined, color: mealColor),
                          contentPadding: const EdgeInsets.all(15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                                _obscureText ? Icons.visibility : Icons
                                    .visibility_off,
                                color: mealColor),
                            onPressed: _togglePasswordVisibility,
                          ),
                          hintText: password,
                          hintStyle: const TextStyle(
                              fontSize: 14,
                              color: Colors.white
                          )
                      ),
                      validator: (value) => (value!.isEmpty) ? password : null,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        key: const Key('loginButton'),
                        onPressed: () {
                          if (formGlobalKey.currentState!.validate()) {
                            _loading ? null : _login();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: mealColor
                        ),
                        child: _loading
                            ? const LinearProgressIndicator()
                            : const Text(
                          signIn,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 14
                          ),
                        ),
                      ),
                    ),
                  ],
                )
            ),
          ),
          const BackBtn()
        ],
      ),
    );
  }
}
