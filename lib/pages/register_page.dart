import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_meal_app/components/back_btn.dart';
import 'package:my_meal_app/hive/hive_app_helper.dart';
import 'package:my_meal_app/hive/user.dart';
import 'package:my_meal_app/utils/utils.dart';
import '../components/background_image.dart';
import '../constants.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formGlobalKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  bool _obscureText = true;
  bool _obscureTextConfirm = true;
  bool _loading = false;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggleconfirmPasswordVisibility() {
    setState(() {
      _obscureTextConfirm = !_obscureTextConfirm;
    });
  }

  void _registerUser() async{
    setState(() {
      _loading = true;
    });
    bool isUserExist = await HiveAppHelper().checkUser(_email.text);
    if (isUserExist) {
      Fluttertoast.showToast(msg: emailExist);
      setState(() {
        _loading = false;
      });
    } else {
      Future.delayed(const Duration(seconds: 5), () async {
        bool isCreated = await HiveAppHelper().register(User(name: _name.text, email: _email.text, password: _password.text, credential: ""));
        Fluttertoast.showToast(msg: isCreated ? regisSuccess : regisFailed);
        _name.clear();
        _email.clear();
        _password.clear();
        _confirmPassword.clear();
        setState(() {
          _loading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          const BackgroundImage(imageResource: "assets/images/signup_poster.jpg"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
                key: formGlobalKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const Text(
                      register,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      signupTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _name,
                      readOnly: _loading,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(
                          color: Colors.white
                      ),
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      decoration: InputDecoration(
                          labelText: name,
                          labelStyle: const TextStyle(
                              color: Colors.white
                          ),
                          fillColor: Colors.black.withOpacity(0.2),
                          filled: true,
                          prefixIcon: const Icon(Icons.person, color: mealColor),
                          contentPadding: const EdgeInsets.all(15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: name,
                          hintStyle: const TextStyle(
                              fontSize: 14,
                              color: Colors.white
                          )
                      ),
                      validator: (value) => (value!.isEmpty) ? name : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
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
                      controller: _password,
                      readOnly: _loading,
                      keyboardType: TextInputType.text,
                      obscureText: _obscureText,
                      style: const TextStyle(
                          color: Colors.white
                      ),
                      textInputAction: TextInputAction.next,
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
                    TextFormField(
                      controller: _confirmPassword,
                      readOnly: _loading,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(
                          color: Colors.white
                      ),
                      textInputAction: TextInputAction.done,
                      autocorrect: false,
                      obscureText: _obscureTextConfirm,
                      decoration: InputDecoration(
                          labelText: confirmPassword,
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
                                _obscureTextConfirm ? Icons.visibility : Icons
                                    .visibility_off,
                                color: mealColor),
                            onPressed: _toggleconfirmPasswordVisibility,
                          ),
                          hintText: confirmPassword,
                          hintStyle: const TextStyle(
                              fontSize: 14,
                              color: Colors.white
                          )
                      ),
                      validator: (value) =>
                      (value!.isEmpty || value != _password.text) ? confirmPassword : null,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formGlobalKey.currentState!.validate()) {
                            _loading ? null : _registerUser();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: mealColor
                        ),
                        child: _loading
                            ? const LinearProgressIndicator()
                            : const Text(
                          signUp,
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
