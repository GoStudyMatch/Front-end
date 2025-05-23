/// 채팅 화면
/// 
/// 사용자의 채팅 목록을 표시하는 화면입니다.
/// 스터디 채팅과 개인 채팅을 탭으로 구분하여 표시합니다.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 채팅 화면 위젯
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

/// 채팅 화면의 상태를 관리하는 클래스
class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  /// 탭 컨트롤러
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('채팅'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '스터디 채팅'),
            Tab(text: '개인 채팅'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 스터디 채팅 목록
          _buildStudyChatList(),
          // 개인 채팅 목록
          _buildPersonalChatList(),
        ],
      ),
    );
  }

  /// 스터디 채팅 목록을 생성하는 메서드
  Widget _buildStudyChatList() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        final studyNames = [
          'Flutter 스터디',
          '알고리즘 스터디',
          '영어 회화 스터디',
        ];
        final lastMessages = [
          '다음 모임은 언제인가요?',
          '오늘 문제 풀이 공유해주세요',
          '숙제 다 했어요?',
        ];
        final times = [
          '10:30',
          '09:15',
          '어제',
        ];
        final unreadCounts = [2, 0, 5];

        return _buildChatItem(
          title: studyNames[index],
          lastMessage: lastMessages[index],
          time: times[index],
          unreadCount: unreadCounts[index],
          isStudy: true,
          onTap: () {
            context.push('/chat/study/${index + 1}');
          },
        );
      },
    );
  }

  /// 개인 채팅 목록을 생성하는 메서드
  Widget _buildPersonalChatList() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        final names = [
          '김철수',
          '이영희',
          '박지민',
        ];
        final lastMessages = [
          '안녕하세요!',
          '스터디 같이 하실래요?',
          '다음에 뵙겠습니다',
        ];
        final times = [
          '방금 전',
          '1시간 전',
          '어제',
        ];
        final unreadCounts = [1, 3, 0];

        return _buildChatItem(
          title: names[index],
          lastMessage: lastMessages[index],
          time: times[index],
          unreadCount: unreadCounts[index],
          isStudy: false,
          onTap: () {
            context.push('/chat/personal/${index + 1}');
          },
        );
      },
    );
  }

  /// 채팅 항목 위젯을 생성하는 메서드
  Widget _buildChatItem({
    required String title,
    required String lastMessage,
    required String time,
    required int unreadCount,
    required bool isStudy,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: isStudy ? Colors.blue[100] : Colors.grey[300],
              child: Icon(
                isStudy ? Icons.group : Icons.person,
                color: isStudy ? Colors.blue : Colors.grey[600],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          lastMessage,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (unreadCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 