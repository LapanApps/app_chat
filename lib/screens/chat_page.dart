import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final uuid = const Uuid();
  final user = const types.User(id: 'uia', firstName: 'Ahmad');

  final List<types.Message> messages = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              var newMessage = types.TextMessage(
                author: const types.User(id: '23'),
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                text: 'Hello',
                createdAt: DateTime.now().millisecondsSinceEpoch,
              );
              setState(() {
                messages.insert(0, newMessage);
              });
            },
          ),
        ],
      ),
      body: Chat(
        messages: messages,
        onSendPressed: (types.PartialText message) {
          var newMessage = types.TextMessage(
            author: user,
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: message.text,
            createdAt: DateTime.now().millisecondsSinceEpoch,
          );
          setState(() {
            messages.insert(0, newMessage);
          });
        },
        user: user,
      ),
    );
  }
}
