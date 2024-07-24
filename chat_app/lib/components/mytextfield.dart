import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final Icon icon;
  final String hintText;
  final bool obscureText;
  final FocusNode focusNode;
  const MyTextField({
    super.key,
     required this.controller,
     required this.icon,
     required this.hintText,
     required this.obscureText,
     required this.focusNode 
     });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(kDefaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2, // 5 top and bottom
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
      controller: controller,
        obscureText: obscureText,
        focusNode: focusNode,
        //style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          icon: icon,
          iconColor: Theme.of(context).colorScheme.inversePrimary,
          hintText: hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary)
          
         // hintStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
