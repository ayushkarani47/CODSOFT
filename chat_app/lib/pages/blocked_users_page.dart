import 'package:chat_app/components/user_tile.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class BlockedUsersPage extends StatelessWidget {
  BlockedUsersPage({super.key});

  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();

  //show confirm unblock box
  void _showUnblockBox(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Unblock user"),
          content: const Text("Are you sure you want to unblock this user?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("CANCEL"),
            ),
            TextButton(
              onPressed: () {
                chatService.unblockUser(userId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("User unblocked"),
                  ),
                );
              },
              child: const Text("UNBLOCK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //get current user id
    String userId = authService.getCurrentUser()!.uid;

    return Scaffold(
        appBar: AppBar(
          title: Text("BLOCKED USERS"),
        ),
        body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: chatService.getBlockedUserStream(userId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("An error occured: ${snapshot.error}"),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final blockedUsers = snapshot.data ?? [];

            if (blockedUsers.isEmpty) {
              return Center(
                child: Text("No blocked users"),
              );
            }

            return ListView.builder(
                itemCount: blockedUsers.length,
                itemBuilder: (context, index) {
                  final user = blockedUsers[index];
                  return UserTile(
                      text: user['email'], onTap: () => _showUnblockBox(context,user['uid']));
                });
          },
        ));
  }
}
