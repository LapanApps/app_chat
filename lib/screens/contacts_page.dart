import 'package:app_chat/screens/chat_page.dart';
import 'package:flutter/material.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<String> contacts = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              child: Text(contacts[index][0]),
            ),
            title: Text(contacts[index]),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return ChatPage(
                  name: contacts[index],
                );
              }));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // show modal bottoms sheet
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (_) {
              final nameController = TextEditingController();
              return Padding(
                padding: EdgeInsets.fromLTRB(
                    8, 8, 8, MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Display name',
                      ),
                    ),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                          labelText: 'ID', hintText: 'ID must be unique'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                        onPressed: () {
                          // ignore empty fields
                          if (nameController.text.isEmpty) {
                            return;
                          }
                          setState(() {
                            contacts.add(nameController.text);
                          });
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add'))
                  ],
                ),
              );
            },
          );
        },
        label: const Text('Send a message'),
        icon: const Icon(Icons.message_outlined),
      ),
    );
  }
}
