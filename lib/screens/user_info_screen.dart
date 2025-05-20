import 'package:flutter/material.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  DateTime? _birthDate;
  String? _selectedEducation;
  String? _selectedStatus;
  String? _selectedJobType;
  bool _isStudent = true;

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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // TODO: 사용자 정보 저장 로직 구현
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('사용자 정보 입력'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: '생년월일',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _birthDate == null
                        ? '생년월일을 선택해주세요'
                        : '${_birthDate!.year}년 ${_birthDate!.month}월 ${_birthDate!.day}일',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: '이메일',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이메일을 입력해주세요';
                  }
                  if (!value.contains('@')) {
                    return '올바른 이메일 형식이 아닙니다';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력해주세요';
                  }
                  if (value.length < 6) {
                    return '비밀번호는 6자 이상이어야 합니다';
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
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('저장하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 