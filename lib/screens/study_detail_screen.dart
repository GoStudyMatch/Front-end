/// 스터디 상세 화면
/// 
/// 스터디의 상세 정보를 표시하고 참여 요청을 할 수 있는 화면입니다.
/// 스터디 정보, 멤버 목록, 일정 등을 확인할 수 있습니다.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 스터디 상세 화면 위젯
class StudyDetailScreen extends StatelessWidget {
  /// 스터디 이름
  final String studyName;
  
  /// 스터디 일정
  final String schedule;
  
  /// 스터디 멤버 수
  final int memberCount;
  
  /// 스터디 설명
  final String description;

  const StudyDetailScreen({
    super.key,
    required this.studyName,
    required this.schedule,
    required this.memberCount,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(studyName),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // 스터디 공유 기능
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStudyInfo(),
            _buildMemberList(),
            _buildSchedule(),
            _buildDescription(),
          ],
        ),
      ),
      bottomNavigationBar: _buildJoinButton(context),
    );
  }

  /// 스터디 정보 섹션을 생성하는 메서드
  Widget _buildStudyInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.people, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                '멤버 $memberCount명',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.blue),
              const SizedBox(width: 8),
              const Text(
                '온라인',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 멤버 목록 섹션을 생성하는 메서드
  Widget _buildMemberList() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 8),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '멤버',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              final members = [
                {'name': '김철수', 'role': '스터디장'},
                {'name': '이영희', 'role': '멤버'},
                {'name': '박지민', 'role': '멤버'},
              ];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Text(
                    members[index]['name']![0],
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                title: Text(members[index]['name']!),
                subtitle: Text(members[index]['role']!),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 일정 섹션을 생성하는 메서드
  Widget _buildSchedule() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 8),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '일정',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                schedule,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 설명 섹션을 생성하는 메서드
  Widget _buildDescription() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 8),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '스터디 소개',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  /// 참여 요청 버튼을 생성하는 메서드
  Widget _buildJoinButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200]!,
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          // 참여 요청 다이얼로그 표시
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('스터디 참여 요청'),
              content: const Text('스터디 참여를 요청하시겠습니까?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('취소'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // 참여 요청 처리
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('참여 요청이 전송되었습니다.'),
                      ),
                    );
                  },
                  child: const Text('요청하기'),
                ),
              ],
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Text('참여 요청하기'),
      ),
    );
  }
}

class StudyRoomScreen extends StatelessWidget {
  const StudyRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('스터디방'),
      ),
      body: const Center(
        child: Text('스터디방 화면'),
      ),
    );
  }
} 