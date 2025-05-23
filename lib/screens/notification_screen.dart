/// 알림 화면
/// 
/// 사용자의 알림 목록을 표시하는 화면입니다.
/// 스터디 참여 요청, 새로운 메시지, 스터디 일정 등 다양한 알림을 표시합니다.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 알림 화면 위젯
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림'),
      ),
      body: ListView(
        children: [
          _buildNotificationItem(
            context,
            title: '스터디 참여 요청',
            message: '김철수님이 Flutter 스터디 참여를 요청했습니다.',
            time: '10분 전',
            type: 'study_request',
            onViewProfile: () {
              // 신청자 프로필 보기
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => DraggableScrollableSheet(
                  initialChildSize: 0.7,
                  minChildSize: 0.5,
                  maxChildSize: 0.95,
                  expand: false,
                  builder: (context, scrollController) => SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            '신청자 정보',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Divider(),
                        _buildProfileInfo(
                          '이름',
                          '김철수',
                          Icons.person,
                        ),
                        _buildProfileInfo(
                          '학력',
                          '서울대학교 컴퓨터공학과',
                          Icons.school,
                        ),
                        _buildProfileInfo(
                          '학년',
                          '3학년',
                          Icons.grade,
                        ),
                        _buildProfileInfo(
                          '관심 분야',
                          'Flutter, iOS 개발',
                          Icons.interests,
                        ),
                        _buildProfileInfo(
                          '자기소개',
                          '안녕하세요! Flutter 개발에 관심이 많은 학생입니다. '
                          '함께 성장하는 스터디를 찾고 있습니다.',
                          Icons.description,
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('참여 요청을 거부했습니다'),
                                      ),
                                    );
                                  },
                                  child: const Text('거부'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('참여 요청을 수락했습니다'),
                                      ),
                                    );
                                  },
                                  child: const Text('수락'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          _buildNotificationItem(
            context,
            title: '새로운 메시지',
            message: '알고리즘 스터디에서 새로운 메시지가 도착했습니다.',
            time: '30분 전',
            type: 'message',
          ),
          _buildNotificationItem(
            context,
            title: '스터디 일정',
            message: '내일 오후 2시 Flutter 스터디가 예정되어 있습니다.',
            time: '1시간 전',
            type: 'schedule',
          ),
        ],
      ),
    );
  }

  /// 알림 항목 위젯을 생성하는 메서드
  Widget _buildNotificationItem(
    BuildContext context, {
    required String title,
    required String message,
    required String time,
    required String type,
    VoidCallback? onViewProfile,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getNotificationIcon(type),
                color: _getNotificationColor(type),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          if (type == 'study_request' && onViewProfile != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: onViewProfile,
                    icon: const Icon(Icons.person),
                    label: const Text('신청자 정보 보기'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// 프로필 정보 항목을 생성하는 메서드
  Widget _buildProfileInfo(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  /// 알림 타입에 따른 아이콘을 반환하는 메서드
  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'study_request':
        return Icons.group_add;
      case 'message':
        return Icons.message;
      case 'schedule':
        return Icons.event;
      default:
        return Icons.notifications;
    }
  }

  /// 알림 타입에 따른 색상을 반환하는 메서드
  Color _getNotificationColor(String type) {
    switch (type) {
      case 'study_request':
        return Colors.blue;
      case 'message':
        return Colors.green;
      case 'schedule':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
} 