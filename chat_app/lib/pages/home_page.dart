import 'package:chat_app/components/user_tile.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/my_drawer.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text("Home")),
      ),
      drawer: MyDrawer(
        user: user,
      ),
      body: _buildUserList(),
      //  Column(
      //   children: [
      //     Text(user!.email!),
      //   ],
      // ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUserStreamExcludingBlocked(),
      builder: (context, snapshot) {
        //error
        if (snapshot.hasError) {
          return Center(
            child: Text("An error occured: ${snapshot.error}"),
          );
        }
        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        //return listview
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  //build individual user list tile
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData['email'] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData['email'],
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatPage(
                    receiverID: userData['uid'],
                        reciverEmail: userData['email'],
                      )));
        },
      );
      // GestureDetector(
      //   onTap: () {
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //               builder: (context) => ChatPage(
      //                 receiverID: userData['uid'],
      //                     reciverEmail: userData['email'],
      //                   )));
      //     },
      //   child: Container(
      //     padding: const EdgeInsets.all(10),
      //     margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
      //     decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary,borderRadius: BorderRadius.circular(12)),
      //     child: ListTile(
      //       leading: Icon(Icons.person),
      //       title: Text(userData['email'],style: TextStyle(fontSize:15 ),),
            
      //     ),
      //   ),
      // );
      // return UserTile(
      //   text: userData['email'],
      //   onTap: () {
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) => ChatPage(
      //                   reciverEmail: userData['email'],
      //                 )));
      //   },
      // );
    }
    else{
      return const SizedBox();
    }
  }
}
