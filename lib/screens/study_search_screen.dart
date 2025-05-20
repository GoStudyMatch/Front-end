import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'study_detail_screen.dart';

class StudySearchScreen extends StatefulWidget {
  final String? initialFilter;
  
  const StudySearchScreen({
    super.key,
    this.initialFilter,
  });

  @override
  State<StudySearchScreen> createState() => _StudySearchScreenState();
}

class _StudySearchScreenState extends State<StudySearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late String _selectedFilter;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialFilter ?? 'all';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final uri = GoRouterState.of(context).uri;
    final filter = uri.queryParameters['filter'];
    if (filter != null && filter != _selectedFilter) {
      setState(() {
        _selectedFilter = filter;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: '스터디 검색',
            border: InputBorder.none,
          ),
          onSubmitted: (value) {
            // TODO: 검색 기능 구현
          },
        ),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('전체'),
                  selected: _selectedFilter == 'all',
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = 'all';
                    });
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('내 스터디'),
                  selected: _selectedFilter == 'my',
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = 'my';
                    });
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('추천'),
                  selected: _selectedFilter == 'recommended',
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = 'recommended';
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: 10, // 임시 데이터
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.school,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    title: Text('스터디 ${index + 1}'),
                    subtitle: Text('매주 월, 수, 금'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      context.push('/study/detail/${index + 1}');
                    },
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