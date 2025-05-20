import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String email;
  
  const ProfileScreen({
    super.key,
    required this.email,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _skillController = TextEditingController();
  List<String> skills = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.push('/profile/edit');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 프로필 헤더
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '사용자 이름',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.email,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: _buildStatItem('스터디', '3'),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.grey[300],
                        margin: const EdgeInsets.symmetric(vertical: 4),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            context.push('/follow?tab=followers');
                          },
                          child: _buildStatItem('팔로워', '1.3K'),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.grey[300],
                        margin: const EdgeInsets.symmetric(vertical: 4),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            context.push('/follow?tab=following');
                          },
                          child: _buildStatItem('팔로잉', '13'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // 기본 정보 섹션
            _buildSection(
              '기본 정보',
              [
                _buildInfoItem(Icons.school, '최종학력', '대학교 재학중'),
                _buildInfoItem(Icons.location_on, '거주지역', '서울시 강남구'),
                _buildInfoItem(Icons.work, '직업', '학생'),
              ],
            ),
            // 보유 기술 섹션
            _buildSection(
              '보유 기술',
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _skillController,
                              decoration: const InputDecoration(
                                hintText: '스킬을 입력하세요',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              if (_skillController.text.isNotEmpty) {
                                setState(() {
                                  skills.add(_skillController.text);
                                  _skillController.clear();
                                });
                              }
                            },
                            child: const Text('추가'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: skills.map((skill) => Chip(
                          label: Text(skill),
                          onDeleted: () {
                            setState(() {
                              skills.remove(skill);
                            });
                          },
                        )).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // 자기소개 섹션
            _buildSection(
              '자기소개',
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '안녕하세요! 저는 웹 개발과 모바일 앱 개발에 관심이 있는 학생입니다. '
                    '함께 성장하고 배우는 스터디를 찾고 있습니다.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // 메뉴 리스트
            _buildMenuItem(
              context,
              '알림 설정',
              Icons.notifications,
              () {
                context.push('/notifications/settings');
              },
            ),
            _buildMenuItem(
              context,
              '학습 목표',
              Icons.check_circle_outline,
              () {
                context.push('/todo');
              },
            ),
            _buildMenuItem(
              context,
              '지도',
              Icons.map_outlined,
              () {
                context.push('/map');
              },
            ),
            _buildMenuItem(
              context,
              '도움말',
              Icons.help_outline,
              () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('도움말'),
                    content: const Text(
                      '스터디 파트너 앱 사용 방법에 대한 도움말이 준비 중입니다.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('확인'),
                      ),
                    ],
                  ),
                );
              },
            ),
            _buildMenuItem(
              context,
              '앱 정보',
              Icons.info_outline,
              () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('앱 정보'),
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('버전: 1.0.0'),
                        SizedBox(height: 8),
                        Text('개발자: 스터디 파트너 팀'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('확인'),
                      ),
                    ],
                  ),
                );
              },
            ),
            _buildMenuItem(
              context,
              '로그아웃',
              Icons.logout,
              () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('로그아웃'),
                      content: const Text('정말 로그아웃 하시겠습니까?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('취소'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/',
                              (route) => false,
                            );
                          },
                          child: const Text(
                            '로그아웃',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _skillController.dispose();
    super.dispose();
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 16),
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
      ),
    );
  }

  Widget _buildSkillChips(List<String> skills) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: skills.map((skill) => Chip(
          label: Text(skill),
          onDeleted: () {
            setState(() {
              skills.remove(skill);
            });
          },
        )).toList(),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
            Icon(
              icon,
              color: isDestructive ? Colors.red : Colors.grey[600],
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isDestructive ? Colors.red : Colors.black,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
} 