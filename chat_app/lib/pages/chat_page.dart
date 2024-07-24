import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String reciverEmail;
  final String receiverID;
  ChatPage({super.key, required this.reciverEmail, required this.receiverID});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
 // final ScrollController _scrollController = ScrollController();
  final FocusNode _myfocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Add listener to focus node
    _myfocusNode.addListener(() {
      if (_myfocusNode.hasFocus) {
        //cause a delay to allow the keyboard to show up
        //then the amount of pixels to scroll will be calculated
        //then scroll down
        Future.delayed(const Duration(milliseconds: 500), 
        () =>_scrollToBottom(),
        );

       
      }
    });

  Future.delayed( const Duration(milliseconds: 500), () => _scrollToBottom());

  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  //scrool controller
final ScrollController _scrollController = ScrollController();
void scrollDown(){
  _scrollController.animateTo(
    _scrollController.position.maxScrollExtent,
    duration: Duration(milliseconds: 500),
    curve: Curves.easeOut,
  );
}

  void sendMessages() async {
    if (messageController.text.isNotEmpty) {
      await _chatService.sendMessages(widget.receiverID, messageController.text);
      messageController.clear();
      _scrollToBottom(); // Scroll to bottom after sending a message
    }
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reciverEmail),
      ),
      body: Column(
        children: [
          // Display all the messages
          Expanded(child: _buildMessageList()),
          // Text field
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;

    return StreamBuilder(
      stream: _chatService.getMessage(senderID, widget.receiverID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("An error occurred: ${snapshot.error}"),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        // Scroll to the bottom when new data arrives
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });

        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs
              .map((doc) => _buildMessageItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    bool isCurrentUser = doc['senderID'] == _authService.getCurrentUser()!.uid;
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ChatBubble(
      message: data['message'],
       isCurrentUser: isCurrentUser,
       receiverEmail: widget.reciverEmail,
       messageID: doc.id,
       userID:data['senderID'],
       );
  }

  Widget _buildUserInput() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.all(kDefaultPadding),
            padding: EdgeInsets.symmetric(
              horizontal: kDefaultPadding,
              vertical: kDefaultPadding / 2,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: messageController,
              focusNode: _myfocusNode,
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: "Type a message",
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.blue[400],
            borderRadius: BorderRadius.circular(50),
          ),
          margin: EdgeInsets.only(right: 15),
          child: IconButton(
            padding: EdgeInsets.all(10),
            icon: Icon(
              Icons.arrow_upward,
              color: Colors.white,
            ),
            onPressed: sendMessages,
          ),
        ),
      ],
    );
  }
}
