import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/myTextButton.dart';
import 'package:chat_app/components/mytextfield.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _passConController = TextEditingController();

  final void Function()? onTap;
  RegisterPage({super.key, this.onTap});

  void register(BuildContext context1) async {
    final auth = AuthService();
    if (_passController.text == _passConController.text) {
      try {
        await auth.signUpWithEmailAndPassword(
            _emailController.text, _passConController.text);
        // Navigator.push(context1, MaterialPageRoute(builder: (context)=>HomePage()));
      } catch (e) {
        showDialog(
          context: context1,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    } else {
      showDialog(
        context: context1,
        builder: (context) => const AlertDialog(
          title: Text('Passwords do not match'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    FocusNode focusnode = FocusNode();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 100),
              const Text(
                'Sign Up',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              MyTextField(
                focusNode: focusnode,
                  controller: _emailController,
                  icon: Icon(Icons.email),
                  hintText: "Email",
                  obscureText: false),
              MyTextField(
                focusNode: focusnode,
                  controller: _passController,
                  icon: Icon(Icons.lock),
                  hintText: "Password",
                  obscureText: true),
              const SizedBox(height: 20),
              MyTextField(
                focusNode: focusnode,
                  controller: _passConController,
                  icon: Icon(Icons.lock),
                  hintText: "Confirm Password",
                  obscureText: true),
              const SizedBox(height: 20),
              MyTextButton(
                  onPressed: () => register(context), title: 'Sign up'),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  text: 'Have an account? ',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                  children: [
                    TextSpan(
                      text: 'Login',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = 
                          onTap,
                        
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
