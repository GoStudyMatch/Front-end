/// 채팅방 화면
/// 
/// 스터디 채팅방과 개인 채팅방을 구분하여 표시합니다.
/// 스터디 채팅방의 경우 멤버 목록과 Todo 목록을 확인할 수 있습니다.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 채팅방 화면 위젯
class ChatRoomScreen extends StatefulWidget {
  /// 채팅방 ID
  final String roomId;
  
  /// 채팅방 타입 (study 또는 personal)
  final String type;
  
  /// 채팅방 제목
  final String title;

  const ChatRoomScreen({
    super.key,
    required this.roomId,
    required this.type,
    required this.title,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

/// 채팅방 화면의 상태를 관리하는 클래스
class _ChatRoomScreenState extends State<ChatRoomScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  /// 메시지 입력 컨트롤러
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _todoController = TextEditingController();
  
  /// 메시지 목록
  final List<Map<String, dynamic>> _messages = [];
  final List<Map<String, dynamic>> _todos = [];
  bool _showTodoInput = false;

  /// 공지사항 목록
  final List<String> _notices = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadInitialData();
  }

  void _loadInitialData() {
    // 샘플 메시지 데이터
    _messages.addAll([
      {
        'sender': '김철수',
        'message': '안녕하세요! 오늘 스터디 시작할까요?',
        'time': '10:00',
        'isMe': false,
      },
      {
        'sender': '나',
        'message': '네, 시작하겠습니다!',
        'time': '10:01',
        'isMe': true,
      },
    ]);

    // 샘플 Todo 데이터
    _todos.addAll([
      {
        'title': 'Flutter 기본 위젯 학습',
        'deadline': '2024-03-20',
        'assignee': '김철수',
        'isCompleted': false,
      },
      {
        'title': '알고리즘 문제 풀이',
        'deadline': '2024-03-22',
        'assignee': '전체',
        'isCompleted': true,
      },
    ]);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    _todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title),
            if (widget.type == 'study')
              Text(
                '멤버 5명',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
        actions: [
          if (widget.type == 'study')
            IconButton(
              icon: const Icon(Icons.people),
              onPressed: () => _showMemberList(context),
            ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: _showNotificationSettings,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showMoreMenu,
          ),
        ],
        bottom: widget.type == 'study'
            ? TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: '채팅'),
                  Tab(text: 'Todo'),
                ],
              )
            : null,
      ),
      body: widget.type == 'study'
          ? TabBarView(
              controller: _tabController,
              children: [
                _buildChatTab(),
                _buildTodoTab(),
              ],
            )
          : _buildChatTab(),
    );
  }

  Widget _buildChatTab() {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessageBubble(message);
                },
              ),
              Positioned(
                top: 16,
                right: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  child: IconButton(
                    icon: const Icon(Icons.announcement, color: Colors.blue),
                    onPressed: _showNoticesDialog,
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildTodoTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _todoController,
                  decoration: InputDecoration(
                    hintText: '새로운 목표를 입력하세요',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  if (_todoController.text.isNotEmpty) {
                    setState(() {
                      _todos.add({
                        'title': _todoController.text,
                        'isCompleted': false,
                        'deadline': null,
                        'assignee': null,
                        'createdAt': DateTime.now(),
                      });
                    });
                    _todoController.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('추가'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _todos.length,
            itemBuilder: (context, index) {
              final todo = _todos[index];
              return Dismissible(
                key: Key(todo['title']),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  setState(() {
                    _todos.removeAt(index);
                  });
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      value: todo['isCompleted'],
                      onChanged: (value) {
                        setState(() {
                          todo['isCompleted'] = value;
                        });
                      },
                    ),
                    title: Text(
                      todo['title'],
                      style: TextStyle(
                        decoration: todo['isCompleted']
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (todo['deadline'] != null)
                          Text(
                            '마감일: ${todo['deadline'].toString().split(' ')[0]}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        if (todo['assignee'] != null)
                          Text(
                            '담당자: ${todo['assignee']}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        Text(
                          '생성일: ${todo['createdAt'].toString().split(' ')[0]}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'deadline',
                          child: Text('마감일 설정'),
                        ),
                        const PopupMenuItem(
                          value: 'assignee',
                          child: Text('담당자 지정'),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'deadline') {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          ).then((date) {
                            if (date != null) {
                              setState(() {
                                todo['deadline'] = date;
                              });
                            }
                          });
                        } else if (value == 'assignee') {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('담당자 지정'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: const Text('김철수'),
                                    onTap: () {
                                      setState(() {
                                        todo['assignee'] = '김철수';
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('이영희'),
                                    onTap: () {
                                      setState(() {
                                        todo['assignee'] = '이영희';
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// 메시지 버블 위젯을 생성하는 메서드
  Widget _buildMessageBubble(Map<String, dynamic> message) {
    return Align(
      alignment: message['isMe'] ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: message['isMe'] ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!message['isMe'])
              Text(
                message['sender'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            Text(message['message']),
            Text(
              message['time'],
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200]!,
            offset: const Offset(0, -1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {
              // 파일 첨부
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: '메시지를 입력하세요',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (_messageController.text.isNotEmpty) {
                setState(() {
                  _messages.add({
                    'sender': '나',
                    'message': _messageController.text,
                    'time': '지금',
                    'isMe': true,
                  });
                  _messageController.clear();
                });
              }
            },
          ),
        ],
      ),
    );
  }

  void _showMemberList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '스터디 멤버',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              itemCount: 5, // 샘플 데이터
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text('멤버 ${index + 1}'),
                  subtitle: Text(index == 0 ? '방장' : '멤버'),
                  trailing: index == 0
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.message),
                          onPressed: () {
                            // 개인 메시지 보내기
                          },
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 공지사항 추가 다이얼로그를 표시하는 메서드
  void _showAddNoticeDialog() {
    final TextEditingController noticeController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('공지사항 작성'),
        content: TextField(
          controller: noticeController,
          decoration: const InputDecoration(
            hintText: '공지사항을 입력하세요',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              if (noticeController.text.isNotEmpty) {
                setState(() {
                  _notices.add(noticeController.text);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('공지사항이 등록되었습니다.')),
                );
              }
            },
            child: const Text('등록'),
          ),
        ],
      ),
    );
  }

  /// 공지사항 목록을 표시하는 다이얼로그를 표시하는 메서드
  void _showNoticesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('공지사항'),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.pop(context);
                _showAddNoticeDialog();
              },
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: _notices.isEmpty
              ? const Center(
                  child: Text(
                    '등록된 공지사항이 없습니다.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _notices.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(_notices[index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            setState(() {
                              _notices.removeAt(index);
                            });
                            Navigator.pop(context);
                            _showNoticesDialog();
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }

  /// 알림 설정 다이얼로그를 표시하는 메서드
  void _showNotificationSettings() {
    bool isMuted = false;
    bool isImportantOnly = false;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('알림 설정'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text('알림 끄기'),
                subtitle: const Text('모든 알림을 받지 않습니다'),
                value: isMuted,
                onChanged: (value) {
                  setState(() {
                    isMuted = value;
                    if (value) isImportantOnly = false;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('중요 알림만'),
                subtitle: const Text('멘션과 공지사항만 알림을 받습니다'),
                value: isImportantOnly,
                onChanged: (value) {
                  setState(() {
                    isImportantOnly = value;
                    if (value) isMuted = false;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('알림 설정이 저장되었습니다')),
                );
              },
              child: const Text('저장'),
            ),
          ],
        ),
      ),
    );
  }

  /// 더보기 메뉴를 표시하는 메서드
  void _showMoreMenu() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) => Container(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          )),
          child: Material(
            color: Colors.white,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.15),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(-2, 0),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // 상단 그리드 메뉴
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 4,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      children: [
                        _buildGridMenuItem(
                          icon: Icons.search,
                          label: '검색',
                          onTap: () {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('대화 내용 검색'),
                                content: TextField(
                                  decoration: const InputDecoration(
                                    hintText: '검색어를 입력하세요',
                                    prefixIcon: Icon(Icons.search),
                                  ),
                                  onSubmitted: (value) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('"$value" 검색 결과가 없습니다')),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        _buildGridMenuItem(
                          icon: Icons.file_copy,
                          label: '내보내기',
                          onTap: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('대화 내용이 저장되었습니다')),
                            );
                          },
                        ),
                        _buildGridMenuItem(
                          icon: Icons.photo_library,
                          label: '사진',
                          onTap: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('사진 기능 준비 중입니다')),
                            );
                          },
                        ),
                        _buildGridMenuItem(
                          icon: Icons.calendar_today,
                          label: '일정',
                          onTap: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('일정 기능 준비 중입니다')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey[200]),
                  // 하단 리스트 메뉴
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          leading: Icon(Icons.settings, color: Colors.grey[700]),
                          title: Text('채팅방 설정', style: TextStyle(color: Colors.grey[800])),
                          onTap: () {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('채팅방 설정'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SwitchListTile(
                                      title: const Text('알림'),
                                      value: true,
                                      onChanged: (value) {},
                                    ),
                                    SwitchListTile(
                                      title: const Text('상단 고정'),
                                      value: false,
                                      onChanged: (value) {},
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('확인'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.delete_outline, color: Colors.red[300]),
                          title: Text('대화 내용 삭제', style: TextStyle(color: Colors.red[300])),
                          onTap: () {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('대화 내용 삭제'),
                                content: const Text('모든 대화 내용이 삭제됩니다. 계속하시겠습니까?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('취소'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        _messages.clear();
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('대화 내용이 삭제되었습니다')),
                                      );
                                    },
                                    child: Text('삭제', style: TextStyle(color: Colors.red[300])),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        if (widget.type == 'study')
                          ListTile(
                            leading: Icon(Icons.exit_to_app, color: Colors.red[300]),
                            title: Text('스터디 나가기', style: TextStyle(color: Colors.red[300])),
                            onTap: () {
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('스터디 나가기'),
                                  content: const Text('정말로 스터디를 나가시겠습니까?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('취소'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        context.go('/home');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('스터디를 나갔습니다')),
                                        );
                                      },
                                      child: Text('나가기', style: TextStyle(color: Colors.red[300])),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 그리드 메뉴 아이템을 생성하는 메서드
  Widget _buildGridMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: Colors.blue[300]),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
} 