import 'package:chat_app/services/chat/chat_service.dart';
import 'package:chat_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String receiverEmail;
  final String messageID;
  final String userID;
  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.receiverEmail,
    required this.messageID,
    required this.userID,
  });

  List<String> _splitMessage(String message, int wordsPerLine) {
    List<String> words = message.split(' ');
    List<String> lines = [];

    for (int i = 0; i < words.length; i += wordsPerLine) {
      lines.add(words
          .sublist(i,
              i + wordsPerLine > words.length ? words.length : i + wordsPerLine)
          .join(' '));
    }

    return lines;
  }

  //show options
  void _showOptions(BuildContext context, String messageId,String userId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.flag),
                title: const Text('Report'),
                onTap: () {
                  Navigator.pop(context);
                  // report user
                  _reportMessage(context, messageId, userId);
                  
                },
              ),
              ListTile(
                leading: Icon(Icons.block),
                title: const Text('Block'),
                onTap: () {
                  Navigator.pop(context);
                  // Block user
                  
                  _blockMessage(context, userId);
                  
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () {
                  
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _reportMessage(BuildContext context, String messageId,String otherUserId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Report Message'),
              content:
                  const Text('Are you sure you want to report this message?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // report message

                    ChatService().reportUser(messageId, otherUserId);

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Message Reported'),
                      ),
                    );
                  },
                  child: const Text('Report'),
                ),
              ],
            ));
  }

  void _blockMessage(BuildContext context,String otherUserId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Block User'),
              content: const Text('Are you sure you want to block this user?'),
              actions: [
                TextButton(
                  onPressed: () {

                    Navigator.pop(context);
                   
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // block user

                    ChatService().blockUser(otherUserId);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('User Blocked'),
                      ),
                    );
                  },
                  child: const Text('Block'),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    List<String> messageLines = _splitMessage(message, 7);

    return GestureDetector(
      onLongPress: () {
        if (!isCurrentUser) {
          _showOptions(context, messageID, userID);
          // showDialog(
          //   context: context,
          //   builder: (context) {
          //     return AlertDialog(
          //       title: Text('Block User'),
          //       content: Text('Are you sure you want to block this user?'),
          //       actions: [
          //         TextButton(
          //           onPressed: () {
          //             Navigator.pop(context);
          //           },
          //           child: Text('Cancel'),
          //         ),
          //         TextButton(
          //           onPressed: () {
          //             // Block user
          //             Navigator.pop(context);
          //           },
          //           child: Text('Block'),
          //         ),
          //       ],
          //     );
          //   },
          // );
        }
      },
      child: Align(
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: isCurrentUser
                ? (isDarkMode
                    ? const Color.fromARGB(255, 68, 157, 71)
                    : const Color.fromARGB(255, 92, 226, 97))
                : (isDarkMode
                    ? Color.fromARGB(255, 75, 75, 75)
                    : const Color.fromARGB(255, 240, 240, 240)),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft:
                  isCurrentUser ? Radius.circular(12) : Radius.circular(0),
              bottomRight:
                  isCurrentUser ? Radius.circular(0) : Radius.circular(12),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isCurrentUser ? "You" : receiverEmail,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              ...messageLines
                  .map((line) => Text(
                        line,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
