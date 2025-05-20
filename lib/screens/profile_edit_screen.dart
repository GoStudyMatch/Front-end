import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _selectedEducation;
  String? _selectedStatus;
  String? _selectedJobType;
  bool _isStudent = true;
  bool _isEditingPassword = false;
  bool _isEditingProfile = true;

  final List<String> _educationLevels = [
    '중고등학교',
    '대학교',
    '대학원',
    '직장인',
    '프리랜서',
  ];

  final List<String> _studentStatuses = [
    '재학',
    '휴학',
    '졸업',
  ];

  final List<String> _jobTypes = [
    'IT/개발',
    '금융',
    '교육',
    '의료',
    '서비스',
    '제조업',
    '기타',
  ];

  @override
  void dispose() {
    _nicknameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_isEditingPassword) {
        // TODO: 비밀번호 변경 로직 구현
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('비밀번호가 변경되었습니다.')),
        );
      } else {
        // TODO: 프로필 수정 로직 구현
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('프로필이 수정되었습니다.')),
        );
      }
      Navigator.pop(context);
    }
  }

  void _handleWithdrawal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('회원 탈퇴'),
        content: const Text('정말로 탈퇴하시겠습니까?\n탈퇴 시 모든 데이터가 삭제되며 복구할 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: 회원 탈퇴 로직 구현
              Navigator.pop(context);
              context.go('/');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('탈퇴하기'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원정보 수정'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _handleWithdrawal,
            tooltip: '회원 탈퇴',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment<bool>(
                  value: true,
                  label: Text('프로필 수정'),
                ),
                ButtonSegment<bool>(
                  value: false,
                  label: Text('비밀번호 변경'),
                ),
              ],
              selected: {_isEditingProfile},
              onSelectionChanged: (Set<bool> newSelection) {
                setState(() {
                  _isEditingProfile = newSelection.first;
                  _isEditingPassword = !newSelection.first;
                });
              },
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_isEditingProfile) ...[
                    TextFormField(
                      controller: _nicknameController,
                      decoration: const InputDecoration(
                        labelText: '닉네임',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '닉네임을 입력해주세요';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedEducation,
                      decoration: const InputDecoration(
                        labelText: '최종학력',
                        border: OutlineInputBorder(),
                      ),
                      items: _educationLevels.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedEducation = newValue;
                          _isStudent = newValue != '직장인' && newValue != '프리랜서';
                          _selectedStatus = null;
                          _selectedJobType = null;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '최종학력을 선택해주세요';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    if (_isStudent && _selectedEducation != null)
                      DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        decoration: const InputDecoration(
                          labelText: '학적 상태',
                          border: OutlineInputBorder(),
                        ),
                        items: _studentStatuses.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedStatus = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '학적 상태를 선택해주세요';
                          }
                          return null;
                        },
                      ),
                    if (!_isStudent && _selectedEducation != null) ...[
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedJobType,
                        decoration: const InputDecoration(
                          labelText: '업종',
                          border: OutlineInputBorder(),
                        ),
                        items: _jobTypes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedJobType = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '업종을 선택해주세요';
                          }
                          return null;
                        },
                      ),
                    ],
                  ] else ...[
                    TextFormField(
                      controller: _currentPasswordController,
                      decoration: const InputDecoration(
                        labelText: '현재 비밀번호',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '현재 비밀번호를 입력해주세요';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _newPasswordController,
                      decoration: const InputDecoration(
                        labelText: '새 비밀번호',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '새 비밀번호를 입력해주세요';
                        }
                        if (value.length < 6) {
                          return '비밀번호는 6자 이상이어야 합니다';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: '새 비밀번호 확인',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '비밀번호를 다시 입력해주세요';
                        }
                        if (value != _newPasswordController.text) {
                          return '비밀번호가 일치하지 않습니다';
                        }
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(_isEditingProfile ? '프로필 수정' : '비밀번호 변경'),
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