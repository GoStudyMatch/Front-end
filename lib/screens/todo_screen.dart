import 'package:flutter/material.dart';

class TodoItem {
  String id;
  String title;
  bool isCompleted;
  DateTime createdAt;

  TodoItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final List<TodoItem> _todos = [];
  final _textController = TextEditingController();
  bool _isPublic = true;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _addTodo(String title) {
    if (title.isEmpty) return;
    setState(() {
      _todos.add(
        TodoItem(
          id: DateTime.now().toString(),
          title: title,
        ),
      );
    });
    _textController.clear();
  }

  void _toggleTodo(String id) {
    setState(() {
      final todo = _todos.firstWhere((todo) => todo.id == id);
      todo.isCompleted = !todo.isCompleted;
    });
  }

  void _deleteTodo(String id) {
    setState(() {
      _todos.removeWhere((todo) => todo.id == id);
    });
  }

  void _toggleVisibility() {
    setState(() {
      _isPublic = !_isPublic;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isPublic ? '공개로 설정되었습니다.' : '비공개로 설정되었습니다.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('학습 목표'),
        actions: [
          IconButton(
            icon: Icon(_isPublic ? Icons.visibility : Icons.visibility_off),
            onPressed: _toggleVisibility,
            tooltip: _isPublic ? '비공개로 변경' : '공개로 변경',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: '새로운 목표를 입력하세요',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _addTodo,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _addTodo(_textController.text),
                  child: const Text('추가'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return Dismissible(
                  key: Key(todo.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) => _deleteTodo(todo.id),
                  child: Card(
                    child: ListTile(
                      leading: Checkbox(
                        value: todo.isCompleted,
                        onChanged: (_) => _toggleTodo(todo.id),
                      ),
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      subtitle: Text(
                        '${todo.createdAt.year}년 ${todo.createdAt.month}월 ${todo.createdAt.day}일',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 