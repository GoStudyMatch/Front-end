import 'package:flutter/material.dart';

class StudyDetailScreen extends StatelessWidget {
  final String studyName;
  final String schedule;
  final int memberCount;
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 스터디 이미지
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: const Center(
                child: Icon(
                  Icons.school,
                  size: 80,
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 스터디 정보
                  const Text(
                    '스터디 정보',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.calendar_today, '일정', schedule),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.people, '인원', '$memberCount명'),
                  const SizedBox(height: 16),
                  // 스터디 설명
                  const Text(
                    '스터디 설명',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              // TODO: 스터디방으로 이동
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StudyRoomScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              '스터디방 입장하기',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 20),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(width: 16),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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