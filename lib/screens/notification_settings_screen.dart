import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _studyNotifications = true;
  bool _chatNotifications = true;
  bool _noticeNotifications = true;
  bool _studyJoinNotifications = true;
  bool _studyLeaveNotifications = true;
  bool _studyUpdateNotifications = true;

  void _handleSubmit() {
    // TODO: 알림 설정 저장 로직 구현
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('알림 설정이 저장되었습니다.')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림 설정'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('스터디 알림'),
            subtitle: const Text('스터디 관련 모든 알림을 받습니다'),
            value: _studyNotifications,
            onChanged: (bool value) {
              setState(() {
                _studyNotifications = value;
                if (!value) {
                  _studyJoinNotifications = false;
                  _studyLeaveNotifications = false;
                  _studyUpdateNotifications = false;
                }
              });
            },
          ),
          if (_studyNotifications) ...[
            SwitchListTile(
              title: const Text('스터디 참여 알림'),
              subtitle: const Text('새로운 멤버가 스터디에 참여할 때 알림을 받습니다'),
              value: _studyJoinNotifications,
              onChanged: (bool value) {
                setState(() {
                  _studyJoinNotifications = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('스터디 퇴장 알림'),
              subtitle: const Text('멤버가 스터디를 나갈 때 알림을 받습니다'),
              value: _studyLeaveNotifications,
              onChanged: (bool value) {
                setState(() {
                  _studyLeaveNotifications = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('스터디 업데이트 알림'),
              subtitle: const Text('스터디 정보가 업데이트될 때 알림을 받습니다'),
              value: _studyUpdateNotifications,
              onChanged: (bool value) {
                setState(() {
                  _studyUpdateNotifications = value;
                });
              },
            ),
          ],
          const Divider(),
          SwitchListTile(
            title: const Text('채팅 알림'),
            subtitle: const Text('새로운 메시지가 도착할 때 알림을 받습니다'),
            value: _chatNotifications,
            onChanged: (bool value) {
              setState(() {
                _chatNotifications = value;
              });
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('공지사항 알림'),
            subtitle: const Text('시스템 공지사항을 받습니다'),
            value: _noticeNotifications,
            onChanged: (bool value) {
              setState(() {
                _noticeNotifications = value;
              });
            },
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('설정 저장'),
            ),
          ),
        ],
      ),
    );
  }
} 