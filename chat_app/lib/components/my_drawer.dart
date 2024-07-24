import 'package:chat_app/services/auth/auth_service.dart';

import 'package:chat_app/pages/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final User? user;
   const MyDrawer({super.key, required this.user});
   void logout() {
    final _auth = AuthService();
    
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
                  children: [
             DrawerHeader(
              decoration: BoxDecoration(color:Colors.amber),
              child: Center(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(user!.email!),
                ),
              ),
              
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: ListTile(
                    leading: Icon(Icons.home),
                    title: const Text('H O M E'),
                    onTap: () {
                      Navigator.pop(context);
                    },),
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: ListTile(
                    leading: Icon(Icons.settings),
                    title: const Text('S E T T I N G S'),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingsPage()));
                    },),
                ),
                
            
                
                  ],
                ),
                Padding(
              padding: const EdgeInsets.all(25.0),
              child: ListTile(
                leading: Icon(Icons.logout_rounded),
                title: const Text('L O G O U T'),
                onTap: logout,
            ),
            )
          ],
        ));
  }
}
