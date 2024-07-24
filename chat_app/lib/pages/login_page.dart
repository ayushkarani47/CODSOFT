import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/myTextButton.dart';
import 'package:chat_app/components/mytextfield.dart';
//import 'package:chat_app/pages/home_page.dart';
//import 'package:chat_app/pages/register_page.dart';
import 'package:chat_app/themes/theme_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final void Function()? onTap;
  void login(BuildContext context1) async {
    final authService = AuthService();

    try {
      await authService.signInWithEmailAndPassword(
          _emailController.text, _passController.text);
      //Navigator.push(context1, MaterialPageRoute(builder: (context)=>HomePage()));
    } catch (e) {
      showDialog(
          context: context1,
          builder: (context) => AlertDialog(
                title: Text(e.toString()),
              ));
    }
  }

  LoginPage({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    FocusNode focusnode = FocusNode();
     bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return Scaffold(
     
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100),
             Text(
              'Login',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: isDarkMode?Colors.white:Colors.black),
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
            MyTextButton(onPressed: () { login(context);}, title: 'Login'),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                text: 'Don\'t have an account? ',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
                children: [
                  TextSpan(
                    text: 'Sign up',
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
      )),
    );
  }
}
