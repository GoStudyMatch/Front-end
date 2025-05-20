import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'chat_room_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('채팅'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: const Icon(
                Icons.person,
                color: Colors.grey,
              ),
            ),
            title: Text('채팅방 ${index + 1}'),
            subtitle: Text('마지막 메시지 ${index + 1}'),
            trailing: Text('${index + 1}분 전'),
            onTap: () {
              context.push('/chat/${index + 1}');
            },
          );
        },
      ),
    );
  }
} 