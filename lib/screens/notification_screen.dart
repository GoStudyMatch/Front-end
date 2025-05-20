import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Notification {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  bool isRead;
  final String? studyId;
  final String? chatRoomId;

  Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    this.isRead = false,
    this.studyId,
    this.chatRoomId,
  });
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Notification> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    // 임시 데이터 로드
    setState(() {
      _notifications.addAll([
        Notification(
          id: '1',
          title: '스터디 초대',
          message: '알고리즘 스터디에 초대되었습니다.',
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
          studyId: '1',
        ),
        Notification(
          id: '2',
          title: '새로운 메시지',
          message: '스터디 채팅방에 새로운 메시지가 있습니다.',
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
          chatRoomId: '1',
        ),
        Notification(
          id: '3',
          title: '스터디 일정 변경',
          message: '다음 주 스터디 일정이 변경되었습니다.',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          studyId: '2',
        ),
      ]);
    });
  }

  void _markAsRead(String id) {
    setState(() {
      final notification = _notifications.firstWhere((n) => n.id == id);
      notification.isRead = true;
    });
  }

  void _handleNotificationTap(Notification notification) {
    _markAsRead(notification.id);
    if (notification.studyId != null) {
      context.push('/study/detail/${notification.studyId}');
    } else if (notification.chatRoomId != null) {
      context.push('/chat/${notification.chatRoomId}');
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.push('/notifications/settings');
            },
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? const Center(
              child: Text('알림이 없습니다.'),
            )
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return Dismissible(
                  key: Key(notification.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      _notifications.removeAt(index);
                    });
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: notification.isRead
                          ? Colors.grey[300]
                          : Colors.orange,
                      child: Icon(
                        notification.studyId != null
                            ? Icons.school
                            : Icons.chat,
                        color: notification.isRead
                            ? Colors.grey[600]
                            : Colors.white,
                      ),
                    ),
                    title: Text(
                      notification.title,
                      style: TextStyle(
                        fontWeight: notification.isRead
                            ? FontWeight.normal
                            : FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notification.message),
                        Text(
                          _getTimeAgo(notification.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    onTap: () => _handleNotificationTap(notification),
                  ),
                );
              },
            ),
    );
  }
} 