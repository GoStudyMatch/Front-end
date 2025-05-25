/// 프로필 화면
/// 
/// 사용자의 프로필 정보를 표시하고 관리하는 화면입니다.
/// 기본 정보, 보유 기술, 자기소개 등을 표시하며,
/// 프로필 수정, 알림 설정, 학습 목표 등의 기능을 제공합니다.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'login_screen.dart';

/// 프로필 화면 위젯
class ProfileScreen extends StatefulWidget {
  /// 사용자의 이메일
  final String? email;
  
  const ProfileScreen({
    super.key,
    this.email,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

/// 프로필 화면의 상태를 관리하는 클래스
class _ProfileScreenState extends State<ProfileScreen> {
  /// 스킬 입력 컨트롤러
  final TextEditingController _skillController = TextEditingController();
  
  /// 보유 스킬 목록
  List<String> skills = [];

  /// 자기소개 텍스트
  String _bio = '안녕하세요! 저는 웹 개발과 모바일 앱 개발에 관심이 있는 학생입니다. 함께 성장하고 배우는 스터디를 찾고 있습니다.';
  bool _isEditingBio = false;
  final TextEditingController _bioController = TextEditingController();

  /// 직업
  String _occupation = '학생';
  
  /// 최종학력
  String _education = '대학교';
  
  /// 재학상태
  String _educationStatus = '재학중';

  /// 직업별 최종학력 상태 옵션
  Map<String, List<String>> _educationStatusOptions = {
    '학생': ['재학중', '휴학중', '졸업'],
    '직장인': ['재직중', '이직준비중', '퇴사'],
    '프리랜서': ['활동중', '휴식중', '종료'],
  };

  /// 학력별 상태 옵션
  Map<String, List<String>> _educationLevelStatusOptions = {
    '중학교': ['재학중', '졸업'],
    '고등학교': ['재학중', '졸업'],
    '대학교': ['재학중', '휴학중', '졸업'],
    '대학원': ['재학중', '휴학중', '졸업'],
  };

  @override
  void initState() {
    super.initState();
    _bioController.text = _bio;
  }

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
                    widget.email ?? '',
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
                _buildInfoItem(
                  Icons.school,
                  '최종학력',
                  '$_education $_educationStatus',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('최종학력 선택'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: const Text('중학교'),
                              onTap: () {
                                setState(() {
                                  _education = '중학교';
                                  _educationStatus = _educationLevelStatusOptions['중학교']![0];
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('고등학교'),
                              onTap: () {
                                setState(() {
                                  _education = '고등학교';
                                  _educationStatus = _educationLevelStatusOptions['고등학교']![0];
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('대학교'),
                              onTap: () {
                                setState(() {
                                  _education = '대학교';
                                  _educationStatus = _educationLevelStatusOptions['대학교']![0];
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('대학원'),
                              onTap: () {
                                setState(() {
                                  _education = '대학원';
                                  _educationStatus = _educationLevelStatusOptions['대학원']![0];
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                _buildInfoItem(
                  Icons.school,
                  '학적상태',
                  _educationStatus,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('학적상태 선택'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: _educationLevelStatusOptions[_education]!
                              .map((status) => ListTile(
                                    title: Text(status),
                                    onTap: () {
                                      setState(() {
                                        _educationStatus = status;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ))
                              .toList(),
                        ),
                      ),
                    );
                  },
                ),
                _buildInfoItem(
                  Icons.location_on,
                  '거주지역',
                  '서울시 강남구',
                ),
                _buildInfoItem(
                  Icons.work,
                  '직업',
                  _occupation,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('직업 선택'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: const Text('학생'),
                              onTap: () {
                                _changeOccupation('학생');
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('직장인'),
                              onTap: () {
                                _changeOccupation('직장인');
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('프리랜서'),
                              onTap: () {
                                _changeOccupation('프리랜서');
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                if (_occupation != '학생')
                  _buildInfoItem(
                    Icons.business,
                    '상태',
                    _educationStatus,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('상태 선택'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: _educationStatusOptions[_occupation]!
                                .map((status) => ListTile(
                                      title: Text(status),
                                      onTap: () {
                                        _changeEducationStatus(status);
                                        Navigator.pop(context);
                                      },
                                    ))
                                .toList(),
                          ),
                        ),
                      );
                    },
                  ),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_isEditingBio)
                            Expanded(
                              child: TextField(
                                controller: _bioController,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                  hintText: '자기소개를 입력하세요',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            )
                          else
                            Expanded(
                              child: Text(
                                _bio,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[800],
                                  height: 1.5,
                                ),
                              ),
                            ),
                          IconButton(
                            icon: Icon(_isEditingBio ? Icons.check : Icons.edit),
                            onPressed: _isEditingBio ? _saveBio : _toggleBioEdit,
                          ),
                        ],
                      ),
                    ],
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
                            context.go('/login');
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
    _bioController.dispose();
    super.dispose();
  }

  void _toggleBioEdit() {
    setState(() {
      _isEditingBio = !_isEditingBio;
      if (!_isEditingBio) {
        _bioController.text = _bio;
      }
    });
  }

  void _saveBio() {
    setState(() {
      _bio = _bioController.text;
      _isEditingBio = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('자기소개가 수정되었습니다.')),
    );
  }

  void _changeOccupation(String occupation) {
    setState(() {
      _occupation = occupation;
      _educationStatus = _educationStatusOptions[occupation]![0];
    });
  }

  void _changeEducationStatus(String status) {
    setState(() {
      _educationStatus = status;
    });
  }

  /// 섹션 위젯을 생성하는 메서드
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

  /// 정보 항목 위젯을 생성하는 메서드
  Widget _buildInfoItem(IconData icon, String label, String value, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
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
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
          ],
        ),
      ),
    );
  }

  /// 스킬 칩 위젯을 생성하는 메서드
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

  /// 통계 항목 위젯을 생성하는 메서드
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

  /// 메뉴 항목 위젯을 생성하는 메서드
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