import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class User {
  final String id;
  final String name;
  final String? profileImage;
  bool isFollowing;

  User({
    required this.id,
    required this.name,
    this.profileImage,
    this.isFollowing = false,
  });
}

class FollowRequest {
  final String id;
  final User user;
  final DateTime requestedAt;

  FollowRequest({
    required this.id,
    required this.user,
    required this.requestedAt,
  });
}

class FollowScreen extends StatefulWidget {
  final String? initialTab;

  const FollowScreen({
    super.key,
    this.initialTab,
  });

  @override
  State<FollowScreen> createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<User> _followers = [];
  final List<User> _following = [];
  final List<String> _tabs = ['팔로워', '팔로잉'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: widget.initialTab == 'following' ? 1 : 0,
    );
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadData() {
    // 임시 데이터 로드
    setState(() {
      _followers.addAll([
        User(id: '1', name: '팔로워1', profileImage: 'https://via.placeholder.com/50'),
        User(id: '2', name: '팔로워2', profileImage: 'https://via.placeholder.com/50'),
      ]);
      _following.addAll([
        User(id: '3', name: '팔로잉1', profileImage: 'https://via.placeholder.com/50', isFollowing: true),
        User(id: '4', name: '팔로잉2', profileImage: 'https://via.placeholder.com/50', isFollowing: true),
      ]);
    });
  }

  void _handleFollow(User user) {
    setState(() {
      user.isFollowing = !user.isFollowing;
      if (user.isFollowing) {
        _following.add(user);
      } else {
        _following.removeWhere((u) => u.id == user.id);
      }
    });
  }

  Widget _buildUserList(List<User> users, {bool showFollowButton = true}) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: const Icon(Icons.person, color: Colors.grey),
          ),
          title: Text(user.name),
          trailing: showFollowButton
              ? TextButton(
                  onPressed: () => _handleFollow(user),
                  child: Text(
                    user.isFollowing ? '언팔로우' : '팔로우',
                    style: TextStyle(
                      color: user.isFollowing ? Colors.red : Colors.blue,
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('팔로우 관리'),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUserList(_followers, showFollowButton: false),
          _buildUserList(_following),
        ],
      ),
    );
  }
} 