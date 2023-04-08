import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:web_socket_client/web_socket_client.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.name});

  final String name;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final socket = WebSocket(Uri.parse('ws://localhost:8080'));
  final List<types.Message> _messages = [];
  late types.User otherUser;
  late types.User me;

  @override
  void initState() {
    super.initState();
    otherUser = types.User(id: widget.name, firstName: widget.name);
    me = const types.User(id: 'Fareez', firstName: 'Fareez');
    // Listen to messages from the server.
    socket.messages.listen((incomingMessage) {
      // Split the response into the JSON string and the "from" string
      List<String> parts = incomingMessage.split(' from ');
      String jsonString = parts[0];

      // Parse the JSON string using the jsonDecode() function
      Map<String, dynamic> data = jsonDecode(jsonString);

      // Access the values from the parsed JSON object
      String id = data['id'];
      String msg = data['msg'];
      String timestamp = data['timestamp'];

      if (id == otherUser.id) {
        onMessageReceived(msg);
      }
    });
  }

  String randomString() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  void onMessageReceived(String message) {
    var newMessage = types.TextMessage(
      author: otherUser,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: message,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    _addMessage(newMessage);
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: me,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    var payload = {
      'id': me.id,
      'msg': message.text,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    };

    socket.send(json.encode(payload));

    _addMessage(textMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.name}'),
      ),
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: me,
        theme: DefaultChatTheme(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Close the connection.
    socket.close();
    super.dispose();
  }
}
